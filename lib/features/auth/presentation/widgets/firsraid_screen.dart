import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _backgroundColor = Color(0xff001233);
const _accentColor = Color(0xffD32F2F);
const _cardColor = Color(0xffF8FAFC);

class EmergencyNumbersScreen extends StatelessWidget {
  const EmergencyNumbersScreen({super.key});

  static const _groups = [
    _EmergencyGroup(
      title: 'Main emergency',
      contacts: [
        _EmergencyContact(
          title: 'General emergency',
          number: '112',
          description: 'Unified emergency number from mobile phones.',
          icon: Icons.emergency,
        ),
        _EmergencyContact(
          title: 'Ambulance',
          number: '123',
          description: 'Medical emergencies and urgent patient transport.',
          icon: Icons.local_hospital,
        ),
        _EmergencyContact(
          title: 'Emergency police',
          number: '122',
          description: 'Crimes, danger, accidents, and urgent police help.',
          icon: Icons.local_police,
        ),
        _EmergencyContact(
          title: 'Fire department',
          number: '180',
          description: 'Fires, rescue, and civil protection emergencies.',
          icon: Icons.local_fire_department,
        ),
      ],
    ),
    _EmergencyGroup(
      title: 'Roads and transport',
      contacts: [
        _EmergencyContact(
          title: 'Traffic police',
          number: '128',
          description: 'Traffic accidents and urgent road reports.',
          icon: Icons.traffic,
        ),
        _EmergencyContact(
          title: 'Highway rescue',
          number: '01221110000',
          description: 'Road rescue on major highways.',
          icon: Icons.car_crash,
        ),
        _EmergencyContact(
          title: 'Railway police',
          number: '145',
          description: 'Police reports inside railway services.',
          icon: Icons.train,
        ),
        _EmergencyContact(
          title: 'Railway inquiries',
          number: '15047',
          description: 'Railway information and service support.',
          icon: Icons.confirmation_number,
        ),
        _EmergencyContact(
          title: 'Metro hotline',
          number: '16048',
          description: 'Metro reports, support, and emergency help.',
          icon: Icons.subway,
        ),
        _EmergencyContact(
          title: 'Mobile traffic unit',
          number: '15558',
          description: 'Mobile traffic services and reports.',
          icon: Icons.directions_car,
        ),
      ],
    ),
    _EmergencyGroup(
      title: 'Utilities',
      contacts: [
        _EmergencyContact(
          title: 'Electricity emergency',
          number: '121',
          description: 'Electrical faults, exposed wires, and power hazards.',
          icon: Icons.electric_bolt,
        ),
        _EmergencyContact(
          title: 'Natural gas emergency',
          number: '129',
          description: 'Gas leaks and urgent gas supply hazards.',
          icon: Icons.gas_meter,
        ),
        _EmergencyContact(
          title: 'Natural gas emergency - Cairo',
          number: '149',
          description: 'Gas emergency number used in Cairo.',
          icon: Icons.gas_meter,
        ),
        _EmergencyContact(
          title: 'Water emergency',
          number: '125',
          description: 'Water cuts, leaks, and urgent water faults.',
          icon: Icons.water_drop,
        ),
        _EmergencyContact(
          title: 'Wastewater emergency',
          number: '175',
          description: 'Sewage and sanitation emergencies.',
          icon: Icons.plumbing,
        ),
      ],
    ),
    _EmergencyGroup(
      title: 'Health and protection',
      contacts: [
        _EmergencyContact(
          title: 'Health emergency',
          number: '137',
          description: 'Ministry of Health emergency support.',
          icon: Icons.health_and_safety,
        ),
        _EmergencyContact(
          title: 'Preventive medicine',
          number: '105',
          description: 'Public health and preventive medicine hotline.',
          icon: Icons.medical_information,
        ),
        _EmergencyContact(
          title: 'Addiction treatment',
          number: '16023',
          description: 'Drug addiction treatment and support hotline.',
          icon: Icons.volunteer_activism,
        ),
        _EmergencyContact(
          title: 'Child helpline',
          number: '16000',
          description: 'Reports related to child safety and abuse.',
          icon: Icons.child_care,
        ),
        _EmergencyContact(
          title: 'Homeless rescue',
          number: '16439',
          description: 'Reports to help homeless people in urgent need.',
          icon: Icons.night_shelter,
        ),
      ],
    ),
    _EmergencyGroup(
      title: 'Reports and complaints',
      contacts: [
        _EmergencyContact(
          title: 'Public security',
          number: '115',
          description: 'Security reports and public safety complaints.',
          icon: Icons.security,
        ),
        _EmergencyContact(
          title: 'Cybercrime reports',
          number: '108',
          description: 'Internet crimes and cyber safety reports.',
          icon: Icons.phonelink_lock,
        ),
        _EmergencyContact(
          title: 'Tourist police',
          number: '126',
          description: 'Police support for tourists and tourism areas.',
          icon: Icons.travel_explore,
        ),
        _EmergencyContact(
          title: 'Consumer protection',
          number: '19588',
          description: 'Consumer complaints and protection reports.',
          icon: Icons.verified_user,
        ),
        _EmergencyContact(
          title: 'Government complaints',
          number: '16528',
          description: 'Government complaints hotline.',
          icon: Icons.account_balance,
        ),
        _EmergencyContact(
          title: 'Telecom complaints',
          number: '155',
          description: 'National telecom service complaints.',
          icon: Icons.settings_phone,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        title: const Text('Emergency Numbers'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _EmergencyNotice(),
          const SizedBox(height: 18),
          for (final group in _groups) ...[
            _SectionTitle(group.title),
            const SizedBox(height: 10),
            for (final contact in group.contacts) _EmergencyNumberCard(contact),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  static const _items = [
    _FirstAidItem(
      title: 'CPR / not breathing',
      icon: Icons.favorite,
      warning: 'Call 123 immediately and ask someone to find an AED.',
      steps: [
        'Check the scene is safe, then tap the shoulders and shout.',
        'If there is no normal breathing, place the person on their back.',
        'Push hard and fast in the center of the chest, 100 to 120 times per minute.',
        'If trained, give 30 compressions then 2 rescue breaths. If not trained, keep hands-only CPR going.',
        'Continue until the person breathes normally or medical help takes over.',
      ],
    ),
    _FirstAidItem(
      title: 'Choking - adult or child',
      icon: Icons.air,
      warning: 'If the person cannot cough, talk, cry, or breathe, act fast.',
      steps: [
        'Ask someone to call 123 while you help.',
        'Give 5 firm back blows between the shoulder blades.',
        'Give 5 abdominal thrusts from behind, above the navel.',
        'Repeat 5 back blows and 5 thrusts until the object comes out.',
        'If the person becomes unconscious, lower them to the floor and start CPR.',
      ],
    ),
    _FirstAidItem(
      title: 'Choking - infant',
      icon: Icons.child_friendly,
      warning: 'Do not use abdominal thrusts on babies under 1 year old.',
      steps: [
        'Hold the baby face down on your forearm with the head lower than the body.',
        'Give 5 firm back blows between the shoulder blades.',
        'Turn the baby face up and give 5 chest thrusts with two fingers.',
        'Repeat back blows and chest thrusts while help is on the way.',
        'Start infant CPR if the baby becomes unresponsive and is not breathing.',
      ],
    ),
    _FirstAidItem(
      title: 'Severe bleeding',
      icon: Icons.bloodtype,
      warning: 'Call 123 if bleeding is heavy, spurting, or will not stop.',
      steps: [
        'Wear gloves or use a clean barrier if available.',
        'Press firmly on the wound with clean cloth or gauze.',
        'Keep steady pressure and add more cloth if blood soaks through.',
        'Raise the injured area if it does not cause more pain.',
        'Do not remove deep objects. Press around the object and wait for help.',
      ],
    ),
    _FirstAidItem(
      title: 'Burns',
      icon: Icons.whatshot,
      warning:
          'Call 123 for large, deep, chemical, electrical, face, hand, or airway burns.',
      steps: [
        'Cool the burn under cool running water for 20 minutes.',
        'Remove rings, watches, or tight clothing near the burn if not stuck.',
        'Cover with sterile gauze or clean cloth.',
        'Do not use ice, butter, toothpaste, or oils.',
        'Do not burst blisters.',
      ],
    ),
    _FirstAidItem(
      title: 'Fractures and sprains',
      icon: Icons.personal_injury,
      warning:
          'Call 123 if there is deformity, severe pain, open wound, numbness, or suspected spine injury.',
      steps: [
        'Keep the injured part still.',
        'Support it with padding, clothing, or a splint if you know how.',
        'Apply a cold pack wrapped in cloth for 15 to 20 minutes.',
        'Do not try to push a bone back in place.',
        'Get medical care, especially if the person cannot move or bear weight.',
      ],
    ),
    _FirstAidItem(
      title: 'Fainting',
      icon: Icons.self_improvement,
      warning:
          'Call 123 if the person does not wake quickly, has chest pain, injury, pregnancy, or repeated fainting.',
      steps: [
        'Lay the person flat on their back.',
        'Raise the legs about 30 cm if there is no injury.',
        'Loosen tight clothing and check breathing.',
        'Do not give food or drink until fully awake.',
        'If breathing stops, start CPR.',
      ],
    ),
    _FirstAidItem(
      title: 'Seizure',
      icon: Icons.psychology,
      warning:
          'Call 123 if it lasts more than 5 minutes, happens in water, repeats, or the person is pregnant/injured.',
      steps: [
        'Move nearby objects away and protect the head.',
        'Do not hold the person down.',
        'Do not put anything in the mouth.',
        'After shaking stops, place the person on their side if breathing.',
        'Stay until fully awake and help arrives if needed.',
      ],
    ),
    _FirstAidItem(
      title: 'Stroke signs',
      icon: Icons.face,
      warning: 'Call 123 immediately. Stroke treatment is time-critical.',
      steps: [
        'Use FAST: Face drooping, Arm weakness, Speech trouble, Time to call.',
        'Note the time symptoms started.',
        'Keep the person resting with head slightly raised.',
        'Do not give food, drink, or medicine.',
        'Start CPR if the person becomes unresponsive and is not breathing normally.',
      ],
    ),
    _FirstAidItem(
      title: 'Heart attack / chest pain',
      icon: Icons.monitor_heart,
      warning:
          'Call 123 immediately for chest pressure, shortness of breath, sweating, nausea, or pain spreading to arm/jaw/back.',
      steps: [
        'Help the person sit and rest.',
        'Loosen tight clothing and keep them calm.',
        'If prescribed nitroglycerin, help them take it as directed.',
        'Do not give aspirin unless emergency services or a doctor says so.',
        'Start CPR and use an AED if they become unresponsive and are not breathing normally.',
      ],
    ),
    _FirstAidItem(
      title: 'Poisoning',
      icon: Icons.warning,
      warning:
          'Call 123 or poison support immediately. Keep the container or label.',
      steps: [
        'Move away from the poison if the scene is unsafe.',
        'Do not make the person vomit unless a professional tells you to.',
        'If poison is on skin, rinse with running water and remove contaminated clothing.',
        'If poison is in the eye, rinse gently with clean water.',
        'Tell emergency services what was taken, how much, and when.',
      ],
    ),
    _FirstAidItem(
      title: 'Electric shock',
      icon: Icons.flash_on,
      warning:
          'Call 123 for any serious shock, burn, fall, chest pain, or loss of consciousness.',
      steps: [
        'Do not touch the person while they are still connected to electricity.',
        'Turn off the power source if safe.',
        'Check breathing and responsiveness.',
        'Start CPR if not breathing normally.',
        'Cover burns with clean dry cloth and keep the person warm.',
      ],
    ),
    _FirstAidItem(
      title: 'Heat exhaustion / heatstroke',
      icon: Icons.thermostat,
      warning:
          'Call 123 for confusion, fainting, seizures, very high temperature, or hot dry skin.',
      steps: [
        'Move the person to shade or a cool room.',
        'Remove extra clothing and cool with wet cloths or fanning.',
        'Give small sips of water only if fully awake.',
        'Use ice packs on neck, armpits, and groin for heatstroke signs.',
        'Do not give caffeine or alcohol.',
      ],
    ),
    _FirstAidItem(
      title: 'Allergic reaction',
      icon: Icons.coronavirus,
      warning:
          'Call 123 for swelling of face/throat, breathing trouble, dizziness, or widespread rash.',
      steps: [
        'Help the person avoid the trigger if known.',
        'If they have an epinephrine auto-injector, help them use it as prescribed.',
        'Lay them down with legs raised unless breathing is difficult.',
        'Do not give food or drink if breathing is affected.',
        'Start CPR if they become unresponsive and stop breathing normally.',
      ],
    ),
    _FirstAidItem(
      title: 'Nosebleed',
      icon: Icons.masks,
      warning:
          'Get medical help if bleeding lasts more than 20 minutes, follows injury, or is very heavy.',
      steps: [
        'Sit upright and lean forward.',
        'Pinch the soft part of the nose for 10 to 15 minutes.',
        'Breathe through the mouth.',
        'Do not tilt the head back.',
        'Avoid blowing or picking the nose after bleeding stops.',
      ],
    ),
    _FirstAidItem(
      title: 'Eye chemical splash',
      icon: Icons.visibility,
      warning: 'Call 123 or go to emergency care after rinsing.',
      steps: [
        'Hold the eyelids open and rinse with clean running water.',
        'Keep rinsing for at least 15 to 20 minutes.',
        'Remove contact lenses if easy to remove while rinsing.',
        'Do not rub the eye.',
        'Take the chemical container or name with you if safe.',
      ],
    ),
    _FirstAidItem(
      title: 'Head, neck, or spine injury',
      icon: Icons.accessibility_new,
      warning:
          'Call 123 and avoid moving the person unless there is immediate danger.',
      steps: [
        'Keep the head and neck still.',
        'Tell the person not to move.',
        'Control bleeding with gentle pressure around wounds.',
        'Do not remove helmets unless breathing is blocked.',
        'Start CPR if breathing stops, moving only as much as needed.',
      ],
    ),
    _FirstAidItem(
      title: 'Bites and stings',
      icon: Icons.bug_report,
      warning:
          'Call 123 for breathing trouble, swelling of face/throat, severe reaction, snakebite, or deep animal bite.',
      steps: [
        'Move away from the animal or insect.',
        'Wash the area with soap and water.',
        'Apply a cold pack wrapped in cloth.',
        'For animal bites, cover with clean dressing and get medical care.',
        'For snakebite, keep still and do not cut, suck, or apply ice.',
      ],
    ),
    _FirstAidItem(
      title: 'Drowning',
      icon: Icons.pool,
      warning:
          'Call 123 immediately after rescue, even if the person seems better.',
      steps: [
        'Only rescue if it is safe for you.',
        'Get the person out of water and check breathing.',
        'Start CPR if not breathing normally.',
        'Keep the person warm.',
        'Do not leave them alone because breathing problems can appear later.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        title: const Text('First Aid'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _FirstAidNotice(),
          const SizedBox(height: 18),
          for (final item in _items) _FirstAidCard(item),
        ],
      ),
    );
  }
}

class _EmergencyNotice extends StatelessWidget {
  const _EmergencyNotice();

  @override
  Widget build(BuildContext context) {
    return const _InfoPanel(
      icon: Icons.info,
      title: 'In life-threatening danger, call first.',
      body:
          'Use these numbers for Egypt. Copy the number, call, give your exact location, and stay on the line until the operator tells you what to do.',
    );
  }
}

class _FirstAidNotice extends StatelessWidget {
  const _FirstAidNotice();

  @override
  Widget build(BuildContext context) {
    return const _InfoPanel(
      icon: Icons.medical_services,
      title: 'Quick help, not a replacement for doctors.',
      body:
          'These steps are for immediate first aid. In serious or unclear cases, call 123 and follow the dispatcher instructions.',
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EmergencyNumberCard extends StatelessWidget {
  const _EmergencyNumberCard(this.contact);

  final _EmergencyContact contact;

  Future<void> _copyNumber(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: contact.number));

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${contact.number} copied')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _cardColor,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _copyNumber(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _accentColor.withValues(alpha: 0.12),
                child: Icon(contact.icon, color: _accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.title,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.description,
                      style: const TextStyle(
                        color: Color(0xff4B5563),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    contact.number,
                    style: const TextStyle(
                      color: _accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(Icons.copy, color: Color(0xff6B7280), size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FirstAidCard extends StatelessWidget {
  const _FirstAidCard(this.item);

  final _FirstAidItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _cardColor,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: _accentColor.withValues(alpha: 0.12),
          child: Icon(item.icon, color: _accentColor),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Color(0xff111827),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          item.warning,
          style: const TextStyle(
            color: Color(0xffB91C1C),
            fontSize: 12,
            height: 1.3,
          ),
        ),
        children: [
          for (var i = 0; i < item.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: _accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.steps[i],
                      style: const TextStyle(
                        color: Color(0xff374151),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EmergencyGroup {
  const _EmergencyGroup({required this.title, required this.contacts});

  final String title;
  final List<_EmergencyContact> contacts;
}

class _EmergencyContact {
  const _EmergencyContact({
    required this.title,
    required this.number,
    required this.description,
    required this.icon,
  });

  final String title;
  final String number;
  final String description;
  final IconData icon;
}

class _FirstAidItem {
  const _FirstAidItem({
    required this.title,
    required this.icon,
    required this.warning,
    required this.steps,
  });

  final String title;
  final IconData icon;
  final String warning;
  final List<String> steps;
}
