import 'package:chat_flutter/models/mensajes_response.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/services/chat_service.dart';
import 'package:chat_flutter/services/socket_service.dart';
import 'package:chat_flutter/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [];
  bool _estadoEscribiendo = false;

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial();

    super.initState();
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = new ChatMessage(
        texto: data['mensaje'],
        uid: data['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 400)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void _cargarHistorial() async {
    final usuarioID = chatService.usuarioTo.uid;
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    final history = chat
        .map((m) => new ChatMessage(
            texto: m.mensaje,
            uid: m.from,
            animationController: new AnimationController(
                vsync: this, duration: Duration(milliseconds: 400))
              ..forward()))
        .toList();
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioTo = chatService.usuarioTo;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(usuarioTo.nombre.substring(0, 2),
                    style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(height: 3),
              Text(usuarioTo.nombre,
                  style: TextStyle(color: Colors.black87, fontSize: 12))
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _messages[index],
                  itemCount: _messages.length,
                  reverse: true,
                ),
              ),
              Divider(height: 1),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estadoEscribiendo = true;
                    } else {
                      _estadoEscribiendo = false;
                    }
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: _estadoEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null),
                ))
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estadoEscribiendo = false;
    });
    this.socketService.emit('mensaje-personal', {
      'from': authService.usuario.uid,
      'to': chatService.usuarioTo.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    this.socketService.socket.off('mensaje-personal');
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
