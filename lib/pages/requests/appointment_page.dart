import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/provider.dart';
import '../../services/transaction_service.dart';

class AppointmentPage extends StatefulWidget {
  final ServiceProvider provider;

  const AppointmentPage({super.key, required this.provider});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  static const Color bordeaux = Color(0xFF8B1538);
  static const Color bleuFonce = Color(0xFF17365D);
  static const Color fond = Color(0xFFF6F7FB);

  DateTime? _date;
  TimeOfDay? _time;

  final TextEditingController _note = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final selected = await showDatePicker(
      context: context,
      initialDate: _date ?? today.add(const Duration(days: 1)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bordeaux,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: bleuFonce,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && mounted) {
      setState(() => _date = selected);
    }
  }

  Future<void> _selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bordeaux,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: bleuFonce,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && mounted) {
      setState(() => _time = selected);
    }
  }

  Future<void> _submit() async {
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisissez une date et une heure.'),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final dt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );

    if (!dt.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisissez une date et une heure futures.'),
        ),
      );
      return;
    }

    setState(() => _busy = true);

    try {
      await TransactionService().bookAppointment(
        providerId: widget.provider.id,
        dateTime: dt,
        note: _note.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demande de rendez-vous envoyée.'),
          backgroundColor: bleuFonce,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Réservation impossible : $e'),
          backgroundColor: bordeaux,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: bleuFonce,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _selectionTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE2E6EF)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bordeaux.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: bordeaux,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        color: bleuFonce,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: bleuFonce,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: bleuFonce,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Prendre rendez-vous',
          style: TextStyle(
            color: bleuFonce,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        children: [
          // Prestataire sélectionné
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bleuFonce,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: bleuFonce.withValues(alpha: 0.13),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_pin_circle_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rendez-vous avec',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.provider.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      if (widget.provider.profession != null &&
                          widget.provider.profession!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.provider.profession!,
                          style: const TextStyle(
                            color: Color(0xFFE5C4CF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          const Text(
            'Planifiez votre visite',
            style: TextStyle(
              color: bleuFonce,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Sélectionnez la date et l’heure qui vous conviennent.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          _sectionLabel('Date du rendez-vous'),
          _selectionTile(
            icon: Icons.calendar_month_rounded,
            title: 'Date souhaitée',
            value: _date == null
                ? 'Choisir une date'
                : DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(_date!),
            onTap: _selectDate,
          ),

          const SizedBox(height: 18),

          _sectionLabel('Heure du rendez-vous'),
          _selectionTile(
            icon: Icons.schedule_rounded,
            title: 'Heure souhaitée',
            value: _time == null ? 'Choisir une heure' : _time!.format(context),
            onTap: _selectTime,
          ),

          const SizedBox(height: 22),

          _sectionLabel('Informations complémentaires'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E6EF)),
            ),
            child: TextField(
              controller: _note,
              maxLines: 4,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText:
                    'Précisez votre besoin ou ajoutez une information utile...',
                hintStyle: TextStyle(
                  color: Color(0xFF9AA3B2),
                  fontSize: 13,
                  height: 1.5,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 58),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: bordeaux,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                counterStyle: TextStyle(color: Colors.black45),
              ),
            ),
          ),

          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _busy ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: bordeaux,
                foregroundColor: Colors.white,
                disabledBackgroundColor: bordeaux.withValues(alpha: 0.5),
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _busy
                  ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Envoyer la demande',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 14),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: Colors.black45,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Votre demande sera transmise au prestataire.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
