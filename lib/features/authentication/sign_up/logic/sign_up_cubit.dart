import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vernita/core/storage/auth_token_storage.dart';
import 'package:vernita/features/authentication/log_in/data/models/log_in_request_model.dart';
import 'package:vernita/features/authentication/log_in/data/repo/log_in_repo.dart';
import 'package:vernita/features/authentication/sign_up/data/models/sign_up_request_model.dart';
import 'package:vernita/features/authentication/sign_up/data/repo/sign_up_repo.dart';
import 'package:vernita/features/authentication/sign_up/logic/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepo signUpRepo;
  final LogInRepo logInRepo;
  final AuthTokenStorage authTokenStorage;
  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  SignUpCubit(this.signUpRepo, this.logInRepo, this.authTokenStorage)
    : super(const SignUpState.initial());

  Future<void> emitSignUpState(SignUpRequestModel signUpBodyRequest) async {
    emit(const SignUpState.loading());
    final result = await signUpRepo.signUp(signUpBodyRequest);

    await result.fold(
      (failure) async {
        if (isClosed) return;
        emit(
          SignUpState.failure(errMessage: failure.apiErrorModel.displayMessage),
        );
      },
      (user) async {
        // The register response has no token, so sign in right away with the
        // same credentials. Without a token /users/me (the profile) can't load.
        final signedIn = await _signInAfterSignUp(signUpBodyRequest);
        if (isClosed) return;
        if (signedIn) {
          emit(SignUpState.success(user));
        } else {
          emit(
            const SignUpState.failure(
              errMessage:
                  'Your account was created, but we could not sign you in. Please log in.',
            ),
          );
        }
      },
    );
  }

  Future<bool> _signInAfterSignUp(SignUpRequestModel request) async {
    final loginResult = await logInRepo.logIn(
      LogInRequestModel(
        email: request.email,
        password: request.password,
        rememberMe: false,
      ),
    );

    return loginResult.fold(
      (_) async => false,
      (response) async {
        try {
          await authTokenStorage.saveToken(
            accessToken: response.accessToken,
            rememberMe: false,
          );
          return true;
        } catch (_) {
          return false;
        }
      },
    );
  }
}
