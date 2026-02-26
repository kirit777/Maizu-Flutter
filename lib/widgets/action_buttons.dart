import 'package:flutter/material.dart';

import '../core/constants.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    required this.onUndo,
    required this.onErase,
    required this.onHint,
    required this.onNotes,
    required this.notesEnabled,
    super.key,
  });

  final VoidCallback onUndo;
  final VoidCallback onErase;
  final VoidCallback onHint;
  final VoidCallback onNotes;
  final bool notesEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(label: 'Undo', onTap: onUndo),
        _ActionButton(label: 'Erase', onTap: onErase),
        _ActionButton(label: 'Hint', onTap: onHint),
        _ActionButton(label: notesEnabled ? 'Note ✓' : 'Note', onTap: onNotes),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) {
        setState(() => _scale = 1);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.darkTeal,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white30),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
