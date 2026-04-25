import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: <Widget>[
              CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFFF6B35),
                child: Text(
                  'HA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hasitha Alamanda',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text('hasitha@email.com'),
                  ],
                ),
              ),
              Icon(Icons.edit_outlined),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _optionTile(Icons.location_on_outlined, 'Manage addresses'),
        _optionTile(Icons.payments_outlined, 'Payments and refunds'),
        _optionTile(Icons.local_offer_outlined, 'Offers and coupons'),
        _optionTile(Icons.support_agent_outlined, 'Help and support'),
        _optionTile(Icons.settings_outlined, 'App settings'),
      ],
    );
  }

  Widget _optionTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
