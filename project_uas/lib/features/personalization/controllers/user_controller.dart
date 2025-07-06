import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/user/user_repository.dart';
import 'package:project_uas/features/authentication/screens/login/login.dart';
import 'package:project_uas/features/personalization/controllers/widget/gender_option.dart';
import 'package:project_uas/features/personalization/models/user_model.dart';
import 'package:project_uas/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/network_manager.dart';
import 'package:project_uas/utils/local_storage/storage_utility.dart';
import 'package:project_uas/utils/popups/full_screen_loader.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class UserController extends GetxController { 
  static UserController get instance => Get.find(); 

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>(); 
  
  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();

    gender.value = BLocalStorage.safeInstance().readData<String>('Gender') ?? '';
    dateOfBirth.value = BLocalStorage.safeInstance().readData<String>('DateOfBirth') ?? '';
  }

  // Fetch USER Record 
  Future<void> fetchUserRecord() async{
    final userData = await UserRepository.instance.fetchUserDetails();
    user.value = userData;
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider 
  Future<void> saveUserRecord (UserCredential? userCredentials) async { 
    try { 
      // Refresh User Record
      await fetchUserRecord();

      if (user.value.id.isEmpty) {
        if (userCredentials != null) { 
          // Convert Name to First and Last Name 
          final nameParts = UserModel.nameParts (userCredentials.user!.displayName ?? ''); 
          final username = UserModel.generateUsername (userCredentials.user!.displayName ?? ''); 

          // Map Data 
          final user = UserModel( 
            id: userCredentials.user!.uid, 
            firstName: nameParts[0], 
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join('') : '',  
            username: username, 
            email: userCredentials.user!.email ?? '', 
            phoneNumber: userCredentials.user!.phoneNumber ?? '', 
            profilePicture: userCredentials.user!.photoURL ?? '',
          );
          // save data user
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) { 
      BLoaders.warningSnackBar( 
        title: 'Data not saved', 
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.', 
      ); 
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(BSize.md),
      title: 'Delete Account',
      middleText:
      "Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.",
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: BSize.Lg), child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      BFullScreenLoader.openLoadingDialog( 'Processing', BImages.docerAnimation);

      /// First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider. isNotEmpty) {
        // Re Verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          BFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          BFullScreenLoader.stopLoading ();
          Get.to(() => const ReAuthLoginForm());
          }
        }
      } catch (e) {
        BFullScreenLoader.stopLoading();
        BLoaders.warningSnackBar(title: 'Oh Snap! ', message: e. toString());
    }
  }

  /// Re Authentication before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      BFullScreenLoader.openLoadingDialog('Processing', BImages.docerAnimation);

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        BFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword. text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      BFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      BFullScreenLoader.stopLoading();
      BLoaders.warningSnackBar(title: 'Oh Snap!', message:e.toString());
    }
  }

  // Upload Profile Image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        // Upload Image
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile/', image);

        // Update User Image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user. value.profilePicture = imageUrl;
        user.refresh();

        BLoaders. successSnackBar(title: 'Congratulations', message: 'Your Profile Image has been updated! ');
      }
    } catch (e) {
    BLoaders.errorSnackBar(title: 'OhSnap', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }

  void updateGender(String value) {
    gender.value = value;
    BLocalStorage.safeInstance().writeData('Gender', value);
  }

  void updateDateOfBirth(DateTime date) {
    final formatted = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    dateOfBirth.value = formatted;
    BLocalStorage.safeInstance().writeData('DateOfBirth', formatted);
  }

  void selectGenderDialog() {
    final controller = UserController.instance;

    Get.bottomSheet(
      Obx(() {
        final selectedGender = controller.gender.value;
        final isDark = Get.isDarkMode;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Gender', style: Get.textTheme.titleLarge),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderOptionCard(
                    icon: Icons.male,
                    label: 'Male',
                    selected: selectedGender == 'Male',
                    onTap: () {
                      controller.updateGender('Male');
                      Get.back();
                    },
                  ),
                  GenderOptionCard(
                    icon: Icons.female,
                    label: 'Female',
                    selected: selectedGender == 'Female',
                    onTap: () {
                      controller.updateGender('Female');
                      Get.back();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void selectDateOfBirthDialog(BuildContext context) async {
    DateTime? initial = DateTime(2000, 1, 1);
    final currentValue = dateOfBirth.value;

    if (currentValue.isNotEmpty) {
      try {
        final parts = currentValue.split('-');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        initial = DateTime(year, month, day);
      } catch (_) {}
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Get.isDarkMode
            ? ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.blue,
                  surface: Colors.grey[850]!,
                  onSurface: Colors.white,
                ),
              )
            : ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blue,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      updateDateOfBirth(pickedDate);
    }
  }

  void updatePhoneNumberDialog(BuildContext context) {
    final phoneController = TextEditingController(text: user.value.phoneNumber);
    final isDark = Get.isDarkMode;
    final textTheme = Theme.of(context).textTheme;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Wrap(
          runSpacing: 16,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Text(
              'Update Phone Number',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const Divider(),

            // Input field
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'e.g. 08123456789',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final phone = phoneController.text.trim();
                  if (phone.isEmpty) return;

                  user.value.phoneNumber = phone;
                  user.refresh();

                  await userRepository.updateSingleField({'PhoneNumber': phone});
                  await BLocalStorage.safeInstance().writeData('PhoneNumber', phone);

                  Get.back();
                  BLoaders.successSnackBar(title: 'Success', message: 'Phone number updated!');
                },
              ),
            ),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

}