import 'package:chat_flutter/helpers/mostrar_alerta.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/services/socket_service.dart';
import 'package:chat_flutter/widgets/blue_button.dart';
import 'package:chat_flutter/widgets/custom_input.dart';
import 'package:chat_flutter/widgets/labels.dart';
import 'package:chat_flutter/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(title: 'Registro'),
                  _Form(),
                  Labels(
                    ruta: 'login',
                    firstLabel: '¿Ya tienes una cuenta?',
                    linkName: '¡Ingresar ahora!',
                  ),
                  Text('Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200)),
                  SizedBox(
                    height: 0,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Correo',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          BlueButton(
            title: 'Registrar',
            onPressed: authService.autenticando
                ? null
                : () async {
                    final registerOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());
                    if (registerOk == true) {
                      await socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Registro incorrecto', registerOk);
                    }
                  },
          )
        ],
      ),
    );
  }
}
