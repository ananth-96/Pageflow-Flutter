import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: const Text(
          '''
Privacy Policy
Last updated: April 21, 2025

This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.

Interpretation and Definitions
-------------------------------------
Definitions
- Application refers to PageFlow.
- Company refers to PageFlow, based in Kerala, India.
- Personal Data is any information that relates to an identified or identifiable individual.
- Service refers to the PageFlow mobile application.
- You means the individual using the Service.

Types of Data Collected
-------------------------------------
Personal Data
We may collect:
- Email address
- First and last name
- Phone number
- Usage data

Usage Data
May include:
- IP address
- Browser/device type
- Pages visited and duration
- Mobile device information

Information Collected while Using the Application
We may request access to:
- Camera and photo library
- Files (images, audio, PDF)

Use of Your Personal Data
-------------------------------------
We may use your data to:
- Provide and maintain the Service
- Manage your account
- Perform and manage contracts
- Communicate updates or offers
- Analyze app usage and improve features
- Evaluate business restructuring (if any)
- Comply with legal obligations

Sharing Your Data
We may share your information:
- With Service Providers
- During business transfers
- With affiliates and business partners
- With other users (if shared publicly)
- With your consent

Retention of Data
We keep data as long as needed for business and legal purposes. Usage data may be kept for analytics or security.

Transfer of Data
Your data may be transferred and stored in locations outside your region with appropriate safeguards in place.

Deleting Your Data
You can delete or request deletion of your data by:
- Accessing your account settings
- Contacting us directly

Disclosure of Your Data
We may disclose data:
- To comply with legal obligations
- To protect Company rights or users
- In business transfers or restructuring

Security
We use reasonable measures to protect data but cannot guarantee absolute security.

Children's Privacy
We do not knowingly collect data from children under 13. Contact us if you believe your child has submitted personal data.

Third-Party Links
Our app may link to other sites. We are not responsible for their privacy practices.

Changes to this Policy
We may update this policy. Updates will be posted in the app and dated.

Contact Us
For questions, contact:
ananthankrishnasree@outlook.com
          ''',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
    );
  }
}
