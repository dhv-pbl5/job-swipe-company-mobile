import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl5/shared_customization/extensions/build_context.ext.dart';
import 'package:pbl5/view_models/register_view_model.dart';
import 'package:rive/rive.dart';

//git commit -m "PBL-635 <message>"
class RegisterForm extends StatefulWidget {
  final RegisterViewModel viewModel;
  final String systemRoleId;

  RegisterForm({
    super.key,
    required this.viewModel,
    required this.systemRoleId,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(Duration(seconds: 1), () async {
      if (_formKey.currentState!.validate()) {
        await widget.viewModel.onRegisterPressed(
          systemRoleId: widget.systemRoleId,
          onSuccess: () {
            check.fire();
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                isShowLoading = false;
              });
              confetti.fire();
            }).then(
              (e) => Future.delayed(
                Duration(seconds: 1),
                () async => context.pop(),
              ),
            );
          },
          onFailure: (e) {
            debugPrint("Failed to login: $e");
            error.fire();
            Future.delayed(
              Duration(seconds: 2),
              () {
                setState(() {
                  isShowLoading = false;
                });
              },
            );
          },
        );
      } else {
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller:
                                    widget.viewModel.firstNameController,
                                decoration:
                                    InputDecoration(labelText: 'First Name'),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Add some spacing between the fields
                            Expanded(
                              child: TextFormField(
                                controller: widget.viewModel.lastNameController,
                                decoration:
                                    InputDecoration(labelText: 'Last Name'),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: widget.viewModel.emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        TextFormField(
                          controller: widget.viewModel.passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        TextFormField(
                          controller: widget.viewModel.addressController,
                          decoration: InputDecoration(labelText: 'Address'),
                        ),
                        TextFormField(
                          controller: widget.viewModel.phoneController,
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                        ),
                        TextFormField(
                          controller: widget.viewModel.dobController,
                          decoration:
                              InputDecoration(labelText: 'Date of Birth'),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                minVerticalPadding: 0,
                                title: const Text('Male'),
                                onTap: () {
                                  setState(() {
                                    widget.viewModel.gender = true;
                                  });
                                },
                                leading: Radio<bool>(
                                  value: true,
                                  groupValue: widget.viewModel.gender,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      widget.viewModel.gender = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                minVerticalPadding: 0,
                                title: const Text('Female'),
                                onTap: () {
                                  setState(() {
                                    widget.viewModel.gender = false;
                                  });
                                },
                                leading: Radio<bool>(
                                  value: false,
                                  groupValue: widget.viewModel.gender,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      widget.viewModel.gender = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        context.unfocus();
                        signIn(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF77D8E),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.white,
                      ),
                      label: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          wordSpacing: 1.2,
                        ),
                      )),
                )
              ],
            )),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
