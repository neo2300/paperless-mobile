import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/extensions/profile_extension.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';

class UserAccountListTile extends StatelessWidget {
  final LocalUserAccount account;

  final Widget? trailing;
  final VoidCallback? onTap;
  const UserAccountListTile({
    super.key,
    required this.account,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.maxFinite,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
        title: Text(account.profile.uiSettings.user.username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (account.profile.profile.displayName.isNotEmpty)
              Text(account.profile.profile.displayName),
            Text(
              account.serverUrl.replaceFirst(RegExp(r'https?://'), ''),
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ],
        ),
        isThreeLine: account.profile.profile.displayName.isNotEmpty,
        leading: UserAvatar(account: account),
        trailing: trailing,
      ),
    );
  }
}
