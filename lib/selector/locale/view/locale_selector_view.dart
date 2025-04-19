import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:instagram_clone/selector/locale/locale.dart';

class LocaleSelector extends StatelessWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.watch<LocaleBloc>().state;
    return DropdownButton(
      key: const Key('localeSelector_dropdownbutton'),
      value: locale,
      items: [
        DropdownMenuItem(
          value: const Locale('en', 'US'),
          child: Text(
            l10n.enOptionText,
            key: const Key('localeSelector_en_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: const Locale('ru', 'RU'),
          key: const Key('localeSelector_ru_dropdownMenuItem'),
          child: Text(l10n.ruOptionText),
        ),
      ],
      onChanged: (value) => context.read<LocaleBloc>().add(
            LocaleChange(value),
          ),
    );
  }
}

class LocaleModalWidget extends StatelessWidget {
  const LocaleModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const LocaleSelector(),
      title: Text(context.l10n.languageText),
    );
  }
}
