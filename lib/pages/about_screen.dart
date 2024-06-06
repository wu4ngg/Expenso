import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<void> getVersionNumber() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      versionNumber = info.version;
    });
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }

  String? versionNumber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin ứng dụng")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/app_logo_large_light.png',
              height: 128,
            ),
            Center(
                child: Text(
                    "Ứng dụng quản lý chi tiêu đơn giản. \n Proudly made by fowardslash (Tiêu Trí Quang) \n Phiên bản ${versionNumber ?? ''}",
                    textAlign: TextAlign.center)),
            const SizedBox(height: 10),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Dự án",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
                leading: SvgPicture.asset(
                  "assets/images/github-mark.svg",
                  height: 24,
                ),
                onTap: () {
                  _launchUrl("https://github.com/fowardslash/Expenso");
                },
                title: const Text("Github"),
                subtitle: Text(
                  "Dự án này mã nguồn mở và bạn có thể ủng hộ code cho dự án này một cách tự do.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )),
            const SizedBox(height: 10),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Nhà phát triển",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
                leading: SvgPicture.asset(
                  Theme.of(context).colorScheme.brightness == Brightness.light
                      ? "assets/images/github-mark.svg"
                      : "assets/images/github-mark-white.svg",
                  height: 24,
                ),
                onTap: () {
                  _launchUrl("https://github.com/fowardslash");
                },
                title: const Text("Github"),
                subtitle: Text(
                  "Có dự án ở đây (hơi cháy).",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )),
            ListTile(
                leading: Image.asset(
                  "assets/images/In-Blue-96.png",
                  height: 24,
                ),
                title: const Text("LinkedIn"),
                onTap: () {
                  _launchUrl(
                      "https://www.linkedin.com/in/quang-tr%C3%AD-5127b5222/");
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )),
            ListTile(
              leading: SvgPicture.asset(
                "assets/images/logo.svg",
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onBackground,
                    BlendMode.srcIn),
                height: 24,
              ),
              title: const Text("Twitter/X"),
              subtitle: const Text("Chả đăng gì"),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                _launchUrl("https://twitter.com/q4ngg");
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text("Website"),
              subtitle: const Text("Cũng cháy"),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                _launchUrl("https://fowardslash.vercel.app/");
              },
            ),
            const SizedBox(height: 10),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Giấy phép nguồn mở",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                """
MIT License

Copyright (c) 2024 fowardslash

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
                """,
                style: GoogleFonts.inconsolata(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
