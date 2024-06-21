import 'package:english_learning/AdminPanel/vocalupload.dart';
import 'package:flutter/material.dart';
import 'package:english_learning/Components/vocabulary.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // backgroundColor: Colors.amber,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.grey,
                // image: DecorationImage(
                //   image: AssetImage('images/th1.jpeg'),
                //   fit: BoxFit.cover,
                // ),
              ),
              accountName: const Text(
                "User 1",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              accountEmail: const Text(
                "user1@gmail.com",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('Images/profile.jpg'),
                  radius: 30,
                ),
              ),
            ),
            _buildDrawerListItem(
              icon: Icons.data_exploration_outlined,
              title: "Grammar",
              onTap: () {},
            ),
            _buildDrawerListItem(
              icon: Icons.diamond,
              title: "Vocabulary",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Vocabulary()));
              },
            ),
            _buildDrawerListItem(
              icon: Icons.dark_mode_rounded,
              title: "Error Spotting",
              onTap: () {},
            ),
            _buildDrawerListItem(
              icon: Icons.brightness_5_outlined,
              title: "AI Tutor",
              onTap: () {},
            ),
            _buildDrawerListItem(
              icon: Icons.exit_to_app,
              title: "English Translation",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "English Tutor",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildWelcomeContainer(),
          const SizedBox(height: 30),
          _buildActionButtons(context),
          // const SizedBox(height: 30),
          // _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDrawerListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  Widget _buildWelcomeContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(16.0),
      width: 300,
      child: const Column(
        children: [
          Text(
            "Welcome Admin...",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Let's give some funfilled communication",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionCard(
              title: "Vocabulary",
              subtitle: "Build your word power",
              color: Colors.greenAccent,
              icon: Icons.book,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VocalUploader()));
              },
            ),
            const SizedBox(width: 20),
            _buildActionCard(
              title: "Grammar",
              subtitle: "Master the rules",
              color: Colors.blueAccent,
              icon: Icons.school,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionCard(
              title: "Spotting",
              subtitle: "Spot the errors",
              color: Colors.pink.shade400,
              icon: Icons.error_outline,
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Vocabulary()));
              },
            ),
            const SizedBox(width: 20),
            _buildActionCard(
              title: "Phrases",
              subtitle: "Master the rules",
              color: Colors.deepPurple.shade900,
              icon: Icons.message_outlined,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
