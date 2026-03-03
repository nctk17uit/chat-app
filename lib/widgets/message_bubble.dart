import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = false,
       userImage = null,
       username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    isMe
        ? LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withAlpha(200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [Colors.grey.shade200, Colors.grey.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final textColor = isMe ? Colors.white : Colors.black87;

    Widget avatar() {
      if (userImage == null) return const SizedBox(width: 40);
      return CircleAvatar(
        backgroundImage: NetworkImage(userImage!),
        backgroundColor: theme.colorScheme.primary.withAlpha(180),
        radius: 20,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Stack(
              clipBehavior: Clip.none,
              children: [
                avatar(),
                Positioned(left: 28, bottom: -4, child: Container()),
              ],
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (isFirstInSequence && username != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      username!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                PhysicalModel(
                  color: Colors.transparent,
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 18 : 20),
                    topRight: Radius.circular(isMe ? 20 : 18),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF0084FF) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 18 : 20),
                        topRight: Radius.circular(isMe ? 20 : 18),
                        bottomLeft: const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            Stack(
              clipBehavior: Clip.none,
              children: [
                avatar(),
                Positioned(right: 28, bottom: -4, child: Container()),
              ],
            ),
        ],
      ),
    );
  }
}
