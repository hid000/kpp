import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';

/// Готові зображення з визначеними HTTPS-посиланнями.
const List<String> presetAvatarUrls = [
  'https://api.dicebear.com/9.x/avataaars/png?seed=Felix&size=160',
  'https://api.dicebear.com/9.x/avataaars/png?seed=Aneka&size=160',
  'https://api.dicebear.com/9.x/avataaars/png?seed=Jasper&size=160',
  'https://api.dicebear.com/9.x/avataaars/png?seed=Mia&size=160',
  'https://api.dicebear.com/9.x/bottts/png?seed=Orion&size=160',
  'https://api.dicebear.com/9.x/bottts/png?seed=Nova&size=160',
];

/// Діалог вибору фото профілю: набір готових зображень або власне
/// HTTPS-посилання з попереднім переглядом.
///
/// Повертає вибраний URL, порожній рядок — прибрати фото,
/// `null` — скасовано.
Future<String?> showPhotoPickerDialog(
  BuildContext context, {
  required String name,
  String? currentUrl,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _PhotoPickerDialog(name: name, currentUrl: currentUrl),
  );
}

class _PhotoPickerDialog extends StatefulWidget {
  const _PhotoPickerDialog({required this.name, this.currentUrl});

  final String name;
  final String? currentUrl;

  @override
  State<_PhotoPickerDialog> createState() => _PhotoPickerDialogState();
}

class _PhotoPickerDialogState extends State<_PhotoPickerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _url = TextEditingController();
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentUrl;
    if (_selected != null && !presetAvatarUrls.contains(_selected)) {
      _url.text = _selected!;
    }
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  void _useCustomUrl() {
    if (_formKey.currentState!.validate()) {
      setState(() => _selected = _url.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Фото профілю'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: PhotoAvatar(
                  name: widget.name,
                  photoUrl: _selected,
                  size: 96,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Оберіть із готових'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final String url in presetAvatarUrls)
                    InkResponse(
                      key: ValueKey(url),
                      onTap: () => setState(() => _selected = url),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: _selected == url
                                ? colors.primary
                                : Colors.transparent,
                          ),
                        ),
                        child: PhotoAvatar(
                          name: widget.name,
                          photoUrl: url,
                          size: 56,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('або вставте власне посилання'),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'HTTPS-посилання',
                        controller: _url,
                        keyboardType: TextInputType.url,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? null
                            : Validators.httpsUrl(v),
                        onFieldSubmitted: (_) => _useCustomUrl(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SecondaryButton(
                        text: 'Показати',
                        onPressed: _useCustomUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.currentUrl != null && widget.currentUrl!.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: const Text('Прибрати фото'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: _selected == null || _selected == widget.currentUrl
              ? null
              : () => Navigator.pop(context, _selected),
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
