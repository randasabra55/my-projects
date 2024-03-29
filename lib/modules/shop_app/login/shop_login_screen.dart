import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/layout/shop_app/shop_layout.dart';

import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/components/constants.dart';
import 'package:untitled/shared/network/local/cache_helper.dart';

import '../register/shop_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLoginScreen extends StatelessWidget {

  var formKey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context,state){
          if(state is ShopLoginSuccessState)
            {
              if (state.loginModel.status!)
                {
                  print(state.loginModel.message);
                  print(state.loginModel.data?.token);
                  CacheHelper.saveData(key: 'token', value: state.loginModel.data?.token).then((value) {
                    token= state.loginModel.data!.token!;
                    navigateAndFinish(context, ShopLayout());
                  });
                }
              else
                {
                  print(state.loginModel.message);
                  showToast(text: state!.loginModel!.message!, state: ToastStates.ERROR);
                }
            }
        },
        builder: (context,state){
          return Scaffold(

            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.black
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'email should not be empty';
                            }
                            return null;
                          },
                          lable: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'password should not be empty';
                              }
                              return null;
                            },
                            lable: 'Password',
                            prefix: Icons.lock_outline,
                            sufix: ShopLoginCubit.get(context).suffix,
                            onTap:(){
                              ShopLoginCubit.get(context).changePasswordVisibility();
                            },
                            onSubmit: (value){
                              if(formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                            },
                            isPassword: ShopLoginCubit.get(context).isPassword,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(

                          condition: state is! ShopLoginLoadingState,
                          builder: (BuildContext context) {
                            return  defaultButton(
                                function:(){
                                  if(formKey.currentState!.validate())
                                    {
                                      ShopLoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text
                                      );
                                    }
                                },
                                text: 'Login',
                                isUpperCase: true,
                            );
                          },
                          fallback: (BuildContext context) {
                            return Center(child: CircularProgressIndicator());
                          },

                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Don\'t have an account ?'
                            ),
                            defaultTextButton(
                                function: (){
                                  navigateTo(context,ShopRegisterScreen() );
                                },
                                text: 'Register now'
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
