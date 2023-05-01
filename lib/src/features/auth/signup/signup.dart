import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/features/components/components.dart';
import 'package:fellowship/utilities/country_picker/intl_phone_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _dobValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your date of birth';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  String? _relationshipValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your relationship status';
    }
    return null;
  }

  String? _genderValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }

// ...

  String? _selectedGender;
  final TextEditingController _genderController = TextEditingController();

  String? _selectedRelationshipStatus;

  final TextEditingController _relationshipController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontFamily: fontFamilyName,
              ),
        ),
        leading: GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            AppAssetsPath.back,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AppAssetsPath.logo,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  'Join the community of like-minded Christians on wefellowship!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign up now to be a part of the conversation and connect with believers worldwide',
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfilePic(
                        // image: '',
                        onPressed: () {},
                      ),
                      Text(
                        'Name',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'William Branham',
                        ),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Username',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Bro. Branham',
                        ),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _genderController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Select Gender',
                        ),
                        readOnly: true,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: const Text('Select Your Gender'),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedGender = 'Male';
                                        _genderController.text =
                                            _selectedGender!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Male'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedGender = 'Female';
                                        _genderController.text =
                                            _selectedGender!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Female'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedGender = 'Non-binary';
                                        _genderController.text =
                                            _selectedGender!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Non-binary'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedGender = 'Prefer not to say';
                                        _genderController.text =
                                            _selectedGender!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Prefer not to say'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        validator: _genderValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Relationship Status',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _relationshipController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Select your Relationship Status',
                        ),
                        readOnly: true,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: const Text('Select Relationship Status'),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedRelationshipStatus = 'Single';
                                        _relationshipController.text =
                                            _selectedRelationshipStatus!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Single'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedRelationshipStatus = 'Married';
                                        _relationshipController.text =
                                            _selectedRelationshipStatus!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Married'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedRelationshipStatus =
                                            'Divorced';
                                        _relationshipController.text =
                                            _selectedRelationshipStatus!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Divorced'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      setState(() {
                                        _selectedRelationshipStatus = 'Widowed';
                                        _relationshipController.text =
                                            _selectedRelationshipStatus!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Widowed'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        validator: _relationshipValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Bio',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: 'Write something else about you...',
                        ),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Date of Birth',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dobController,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Tap to Select your Birthday',
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dobController.text = formattedDate;
                            });
                          }
                        },
                        validator: _dobValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Telephone Number',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const IntlPhoneField(
                        keyboardType: TextInputType.number,
                        // controller: ,
                        initialCountryCode: 'KE',
                        obscureText: false,
                      ),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'example@gmail.com',
                        ),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Confirm Password',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontFamily: fontFamilyName,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 48)),
                  ),
                  child: const Text('Get Started'),
                ),
                const SizedBox(height: 50),
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(
                          color: kPrimaryColor,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
