import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("Our Developers",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                  color: Colors.indigo
              ),),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContainer(
                  label: 'Aniket Deore',
                  imageAsset: 'Assets/Images/About_Us_Images/aniket_profile.jpg',
                  emailUrl: 'mailto:aniketrdeore@gmail.com',
                  linkedInUrl: 'https://www.linkedin.com/in/aniket-deore-4338b1273?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                  githubUrl: 'https://github.com/Anikettt01',
                ),
                _buildContainer(
                  label: 'Sujal Bhor',
                  imageAsset: 'Assets/Images/About_Us_Images/sujal_profile.jpg',
                  emailUrl: 'mailto:bhorsujal@gmail.com',
                  linkedInUrl: 'https://www.linkedin.com/in/sujal-bhor-7986b2252?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                  githubUrl: 'https://github.com/bhorsujal',
                ),
              ],
            ),
            SizedBox(height: 30.0), // Adjust the spacing between rows
            // Second Row of Containers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContainer(
                  label: 'Atharv Fakatkar',
                  imageAsset: 'Assets/Images/About_Us_Images/atharv_profile.jpg',
                  emailUrl: 'mailto:atharvfakatkar56@gmail.com',
                  linkedInUrl: 'https://www.linkedin.com/in/atharv-fakatkar-6a8a0727b?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                  githubUrl: 'https://github.com/atharvfakatkar',
                ),
                _buildContainer(
                  label: 'Disha Khandelwal',
                  imageAsset: 'Assets/Images/About_Us_Images/disha_profile.jpg',
                  emailUrl: 'mailto:dishak0411@gmail.com',
                  linkedInUrl: 'https://www.linkedin.com/in/disha-khandelwal-0156b9243?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                  githubUrl: 'https://github.com/Dishak0411',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer({
    required String label,
    required String imageAsset,
    required String emailUrl,
    required String linkedInUrl,
    required String githubUrl,
  }) {
    return Container(
      height: 260,
      padding: EdgeInsets.only(left: 10.0,right: 10,top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.brown[50]!,
            Colors.brown[100]!,
          ],
        ),

        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: AssetImage(imageAsset),
                fit: BoxFit.cover,
                width: 140,
                height: 140,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(Icons.email, () => launch(emailUrl)),
              _buildIconButtonSvg('Assets/Images/About_Us_Images/linkedin.svg', () => launch(linkedInUrl)),
              _buildIconButtonSvg('Assets/Images/About_Us_Images/github_icon.svg', () => launch(githubUrl)),
            ],
          ),
        ],
      ),
    );
  }

}

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      iconSize: 32,
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }

  Widget _buildIconButtonSvg(String svgAsset, VoidCallback onPressed) {
    return IconButton(
      iconSize: 32,
      icon: SvgPicture.asset(
        svgAsset,
        width: 32,
        height: 32,
        color: Colors.black,
      ),
      onPressed: onPressed,
    );
  }

