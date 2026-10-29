import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DownloadVideoButton extends StatefulWidget {
  final Uri url;
  final String title, extension, mediaType;
  const DownloadVideoButton({super.key, required this.url, required this.title,
    required this.extension, required this.mediaType});
  @override State<DownloadVideoButton> createState() => _DownloadVideoButtonState();
}

class _DownloadVideoButtonState extends State<DownloadVideoButton> {
  static const channel = MethodChannel('rauny/downloads');
  static final requested = <Uri>{};
  static final inFlight = <Uri, Future<int?>>{};
  bool pending = false, queued = false;
  bool get apple => defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> openDownloads() async {
    try { await channel.invokeMethod<void>('openDownloads', {'url': widget.url.toString()}); }
    catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(apple ? 'Abra Arquivos > No meu iPhone/iPad > Rauny IPTV Player > Downloads.' : 'Abra a pasta Downloads.')));
    }
  }

  @override void initState() {
    super.initState();
    queued = requested.contains(widget.url);
    if (!queued && inFlight.containsKey(widget.url)) download();
  }

  Future<void> download() async {
    if (pending || queued) return;
    setState(() => pending = true);
    Future<int?>? transfer;
    try {
      transfer = inFlight.putIfAbsent(widget.url, () => channel.invokeMethod<int>('download', {
        'url': widget.url.toString(), 'title': widget.title,
        'extension': widget.extension, 'mediaType': widget.mediaType,
      }));
      await transfer;
      requested.add(widget.url);
      if (!mounted) return;
      setState(() => queued = true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(apple ? 'Vídeo salvo em Arquivos > Rauny IPTV Player > Downloads.' : 'Download solicitado. Acompanhe nas notificações do Android.'),
        action: SnackBarAction(label: apple ? 'Compartilhar' : 'Ver downloads', onPressed: openDownloads)));
    } on PlatformException catch (failure) {
      if (!mounted) return;
      final message = switch (failure.code) {
        'UNSUPPORTED_FORMAT' => 'Este conteúdo usa uma playlist ou formato que ainda não pode ser baixado.',
        'PERMISSION_DENIED' => 'Permita salvar arquivos para baixar na pasta Downloads.',
        'BUSY' => 'Aguarde a solicitação de download anterior.',
        _ => 'Não foi possível iniciar o download. Tente novamente.',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível iniciar o download.')));
    } finally {
      if (inFlight[widget.url] == transfer) inFlight.remove(widget.url);
      if (mounted) setState(() => pending = false);
    }
  }

  @override Widget build(BuildContext context) {
    if (kIsWeb || (!apple && defaultTargetPlatform != TargetPlatform.android) ||
        !const ['movie', 'series'].contains(widget.mediaType)) return const SizedBox.shrink();
    return TextButton.icon(onPressed: pending ? null : queued ? openDownloads : download,
      icon: Icon(queued ? Icons.download_done : Icons.download),
      label: Text(pending ? (apple ? 'Baixando...' : 'Iniciando...') : queued ? (apple ? 'Vídeo salvo' : 'Download solicitado') :
        widget.mediaType == 'series' ? 'Baixar episódio' : 'Baixar filme'));
  }
}
