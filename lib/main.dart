import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(LanguageWrapper(child: GuardianAngelApp()));
}

class LanguageWrapper extends StatefulWidget {
  final Widget child;
  const LanguageWrapper({required this.child});

  @override
  State<LanguageWrapper> createState() => _LanguageWrapperState();
}

class _LanguageWrapperState extends State<LanguageWrapper> {
  String lang = "en";

  void toggle() {
    setState(() {
      lang = lang == "en" ? "mr" : "en";
    });
  }

  @override
  Widget build(BuildContext context) {
    return LangInherited(
      lang: lang,
      toggle: toggle,
      child: widget.child,
    );
  }
}

class LangInherited extends InheritedWidget {
  final String lang;
  final VoidCallback toggle;

  const LangInherited({
    required this.lang,
    required this.toggle,
    required Widget child,
  }) : super(child: child);

  static LangInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LangInherited>()!;
  }

  @override
  bool updateShouldNotify(_) => true;
}

////////////////////////////////////////////////////////////
/// 📚 TEXT MAP
////////////////////////////////////////////////////////////

class AppText {
  static Map<String, Map<String, String>> t = {
    "en": {
      "title": "Guardian Angel",
      "safe": "You Are Safe ❤️",
      "live": "Live Tracking",
      "sos": "SOS Emergency",
      "women": "Women Legal Rights",
      "men": "Men Legal Rights",
      "ai": "AI Assistant",
      "change": "Change Language",
      "enterDest": "  Enter destination",
      "showLoc": "Show My Live Location",
      "police": "Nearby Police Station",
      "navigate": "Navigate",
      "analyze": "Analyze",
      "describe": "Describe your situation..."
    },
    "mr": {
      "title": "गार्डियन एंजल",
      "safe": "तुम्ही सुरक्षित आहात ❤️",
      "live": "थेट लोकेशन",
      "sos": "आपत्कालीन मदत",
      "women": "महिला कायदेशीर हक्क",
      "men": "पुरुष कायदेशीर हक्क",
      "ai": "एआय सहाय्यक",
      "change": "भाषा बदला",
      "enterDest": "  गंतव्य टाका",
      "showLoc": "माझे लोकेशन दाखवा",
      "police": "जवळचे पोलीस स्टेशन",
      "navigate": "नेव्हिगेट करा",
      "analyze": "विश्लेषण करा",
      "describe": "तुमची परिस्थिती लिहा..."
    }
  };

  static String get(BuildContext context, String key) {
    final lang = LangInherited.of(context).lang;
    return t[lang]![key]!;
  }
}

class GuardianAngelApp extends StatelessWidget {
  const GuardianAngelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Guardian Angel",
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomeScreen(),
    );
  }
}

////////////////////////////////////////////////////////////
/// HOME SCREEN (UI IMPROVED)
////////////////////////////////////////////////////////////

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void nav(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context)
  {
    final lang = LangInherited.of(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                ),
              ),
              child: Center(
                child: Text("Guardian Angel",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
              ),
            ),
            ListTile(title: Text(AppText.get(context, "live")), onTap: () => nav(context, LiveTracking())),
            ListTile(title: Text(AppText.get(context, "sos")), onTap: () => nav(context, SOSScreen())),
            ListTile(title: Text(AppText.get(context, "women")), onTap: () => nav(context, LegalRights())),
            ListTile(title: Text(AppText.get(context, "men")), onTap: () => nav(context, MenLegalRights())),
            ListTile(title: Text(AppText.get(context, "ai")), onTap: () => nav(context, AIAssistant())),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text(AppText.get(context, "title")),
        actions: [
          IconButton(onPressed: lang.toggle, icon: Icon(Icons.language))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/angel.png', height: 160),
            SizedBox(height: 15),
            Text(AppText.get(context, "safe"), style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: lang.toggle, child: Text(AppText.get(context, "change"))),

            SizedBox(height: 30),

            buildCard(context, "live", Icons.location_on, LiveTracking()),
            buildCard(context, "sos", Icons.warning, SOSScreen()),
            buildCard(context, "women", Icons.gavel, LegalRights()),
            buildCard(context, "men", Icons.gavel, MenLegalRights()),
            buildCard(context, "ai", Icons.smart_toy, AIAssistant()),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
      BuildContext context,
      String key,
      IconData icon,
      Widget page,
      ) {
    // 🔥 VERY IMPORTANT (forces rebuild on language change)
    LangInherited.of(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(AppText.get(context, key)),        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LIVE TRACKING (FULLY WORKING)
////////////////////////////////////////////////////////////
class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {

  TextEditingController destinationController = TextEditingController();

  ////////////////////////////////////////////////////////////
  /// 📍 OPEN LIVE LOCATION
  ////////////////////////////////////////////////////////////
  Future<void> openLiveLocation() async {

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) return;

    Position pos = await Geolocator.getCurrentPosition();

    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  ////////////////////////////////////////////////////////////
  /// 🚓 NEARBY POLICE
  ////////////////////////////////////////////////////////////
  Future<void> openPoliceNearby() async {

    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=police+station");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  ////////////////////////////////////////////////////////////
  /// 🛣️ NAVIGATION TO USER INPUT
  ////////////////////////////////////////////////////////////
  Future<void> navigateToPlace() async {

    String destination = destinationController.text;

    if (destination.isEmpty) return;

    final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(AppText.get(context, "live"))),
      body: Column(
        children: [
          TextField(
            controller: destinationController,
            decoration: InputDecoration(hintText: AppText.get(context, "enterDest")),
          ),
          SizedBox(height: 30),
          ElevatedButton(onPressed: openLiveLocation, child: Text(AppText.get(context, "showLoc"))),
          SizedBox(height: 30),
          ElevatedButton(onPressed: openPoliceNearby, child: Text(AppText.get(context, "police"))),
          SizedBox(height: 30),
          ElevatedButton(onPressed: navigateToPlace, child: Text(AppText.get(context, "navigate"))),

          ],
        ),
    );
  }
}
////////////////////////////////////////////////////////////
/// SOS (FIXED DIALER)
////////////////////////////////////////////////////////////

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  Future<void> call(String num) async {
    final Uri uri = Uri.parse("tel:$num");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget btn(text, number, color) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(250, 55),
        ),
        onPressed: () => call(number),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.get(context, "sos"))),      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            btn("🚨 Call 112", "112", Colors.grey),
            btn("👩 1091 Women Helpline", "1091", Colors.grey),
            btn("📞 181 Distress Helpline", "181", Colors.grey),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LEGAL RIGHTS (COMPLETE)
////////////////////////////////////////////////////////////

class LegalRights extends StatelessWidget {

  final Map<String, List<Map<String, String>>> rights = {

    "Fundamental Constitutional Rights": [
      {"title": "Article 14", "en": "Equality before law", "hi": "कानून के समक्ष समानता", "mr": "कायद्यापुढे समानता"},
      {"title": "Article 15", "en": "No discrimination based on gender", "hi": "लिंग के आधार पर भेदभाव नहीं", "mr": "लिंगावर आधारित भेदभाव नाही"},
      {"title": "Article 16", "en": "Equal opportunity in employment", "hi": "रोजगार में समान अवसर", "mr": "रोजगारात समान संधी"},
      {"title": "Article 21", "en": "Right to life, dignity & privacy", "hi": "जीवन, सम्मान और गोपनीयता का अधिकार", "mr": "जीवन, सन्मान आणि गोपनीयतेचा अधिकार"},
      {"title": "Article 39(d)", "en": "Equal pay for equal work", "hi": "समान कार्य के लिए समान वेतन", "mr": "समान कामासाठी समान वेतन"},
    ],

    "👮 Police & FIR Rights": [
      {"title": "Zero FIR", "en": "File FIR in any police station", "hi": "किसी भी थाने में FIR दर्ज कर सकते हैं", "mr": "कोणत्याही पोलिस ठाण्यात FIR नोंदवू शकता"},
      {"title": "No Night Arrest", "en": "Women cannot be arrested at night", "hi": "महिलाओं को रात में गिरफ्तार नहीं किया जा सकता", "mr": "महिलांना रात्री अटक करता येत नाही"},
      {"title": "Female Officer", "en": "Mandatory during arrest/search", "hi": "गिरफ्तारी के समय महिला अधिकारी आवश्यक", "mr": "अटक करताना महिला पोलिस अधिकारी आवश्यक"},
      {"title": "Free FIR Copy", "en": "You must receive FIR copy free", "hi": "FIR की प्रति मुफ्त मिलती है", "mr": "FIR ची प्रत मोफत मिळते"},
      {"title": "Statement at Home", "en": "Women can record statement at home", "hi": "महिला घर पर बयान दर्ज कर सकती है", "mr": "महिला घरी निवेदन देऊ शकते"},
    ],

    "⚖️ Criminal Laws (IPC)": [
      {"title": "Section 354", "en": "Outraging modesty", "hi": "छेड़छाड़", "mr": "छेडछाड"},
      {"title": "Section 354A", "en": "Sexual harassment", "hi": "यौन उत्पीड़न", "mr": "लैंगिक छळ"},
      {"title": "Section 354B", "en": "Assault with intent to disrobe", "hi": "कपड़े उतारने की कोशिश", "mr": "वस्त्र काढण्याचा प्रयत्न"},
      {"title": "Section 354C", "en": "Voyeurism", "hi": "छिपकर देखना", "mr": "चोरून पाहणे"},
      {"title": "Section 354D", "en": "Stalking", "hi": "पीछा करना", "mr": "पाठलाग करणे"},
      {"title": "Section 376", "en": "Rape law", "hi": "बलात्कार कानून", "mr": "बलात्कार कायदा"},
      {"title": "Section 376AB/376D", "en": "Aggravated rape & gang rape", "hi": "गंभीर बलात्कार व सामूहिक बलात्कार", "mr": "गंभीर व सामूहिक बलात्कार"},
      {"title": "Section 509", "en": "Insulting modesty of a woman", "hi": "महिला का अपमान", "mr": "महिलेचा अपमान"},
      {"title": "Section 326A", "en": "Acid attack punishment", "hi": "एसिड अटैक की सजा", "mr": "ॲसिड हल्ल्याची शिक्षा"},
      {"title": "Section 506", "en": "Criminal intimidation (threats)", "hi": "धमकी देना", "mr": "धमकी देणे"},
    ],

    "🏠 Domestic Violence Act 2005": [
      {"title": "Protection Order", "en": "Court can restrict abuser", "hi": "कोर्ट आरोपी को रोक सकता है", "mr": "न्यायालय आरोपीला रोखू शकते"},
      {"title": "Right to Residence", "en": "Cannot be thrown out of house", "hi": "घर से नहीं निकाला जा सकता", "mr": "घरातून बाहेर काढता येत नाही"},
      {"title": "Monetary Relief", "en": "Financial compensation", "hi": "आर्थिक सहायता", "mr": "आर्थिक मदत"},
      {"title": "Custody Orders", "en": "Temporary child custody", "hi": "बच्चों की अस्थायी देखभाल", "mr": "मुलांची तात्पुरती देखरेख"},
    ],

    "💼 Workplace Rights (POSH Act 2013)": [
      {"title": "Sexual Harassment Protection", "en": "Protection at workplace", "hi": "कार्यस्थल पर सुरक्षा", "mr": "कामाच्या ठिकाणी संरक्षण"},
      {"title": "Internal Complaints Committee", "en": "Mandatory in offices", "hi": "ऑफिस में अनिवार्य समिति", "mr": "कार्यालयात आवश्यक समिती"},
      {"title": "Confidentiality", "en": "Identity must be protected", "hi": "पहचान गुप्त रखी जाती है", "mr": "ओळख गुप्त ठेवली जाते"},
      {"title": "Time-bound Inquiry", "en": "Case must be resolved timely", "hi": "समय पर जांच पूरी होनी चाहिए", "mr": "वेळेत चौकशी पूर्ण झाली पाहिजे"},
    ],

    "👩‍⚖️ Marriage & Family Rights": [
      {"title": "Dowry Prohibition Act", "en": "Dowry is illegal", "hi": "दहेज गैरकानूनी है", "mr": "हुंडा बेकायदेशीर आहे"},
      {"title": "Right to Divorce", "en": "Legal separation rights", "hi": "तलाक का अधिकार", "mr": "घटस्फोटाचा अधिकार"},
      {"title": "Maintenance (CrPC 125)", "en": "Financial support from husband", "hi": "पति से आर्थिक सहायता", "mr": "पतीकडून आर्थिक सहाय्य"},
      {"title": "Child Custody", "en": "Right to seek custody", "hi": "बच्चों की कस्टडी का अधिकार", "mr": "मुलांच्या ताब्याचा अधिकार"},
      {"title": "Protection from Cruelty (498A)", "en": "Against marital abuse", "hi": "घरेलू अत्याचार से सुरक्षा", "mr": "घरगुती अत्याचारापासून संरक्षण"},
    ],

    "🏡 Property & Inheritance Rights": [
      {"title": "Hindu Succession Act", "en": "Equal property rights", "hi": "संपत्ति में समान अधिकार", "mr": "मालमत्तेत समान हक्क"},
      {"title": "Daughter Rights", "en": "Equal share in ancestral property", "hi": "पैतृक संपत्ति में समान हिस्सा", "mr": "पैतृक मालमत्तेत समान हिस्सा"},
      {"title": "Widow Rights", "en": "Right to husband's property", "hi": "पति की संपत्ति पर अधिकार", "mr": "पतीच्या मालमत्तेवर हक्क"},
    ],

    "🏥 Health & Medical Rights": [
      {"title": "Free Medical Treatment", "en": "For rape victims", "hi": "बलात्कार पीड़ितों के लिए मुफ्त इलाज", "mr": "बलात्कार पीडितांसाठी मोफत उपचार"},
      {"title": "Privacy Rights", "en": "Dignity during examination", "hi": "जांच के दौरान सम्मान", "mr": "तपासणीदरम्यान सन्मान"},
      {"title": "No Two-Finger Test", "en": "Illegal practice", "hi": "गैरकानूनी जांच", "mr": "बेकायदेशीर चाचणी"},
      {"title": "Consent Required", "en": "No treatment without consent", "hi": "बिना अनुमति इलाज नहीं", "mr": "परवानगीशिवाय उपचार नाही"},
    ],

    "💻 Cyber Safety Laws": [
      {"title": "Cyber Stalking", "en": "Punishable offense", "hi": "दंडनीय अपराध", "mr": "दंडनीय गुन्हा"},
      {"title": "Online Harassment", "en": "Legal action available", "hi": "कानूनी कार्रवाई संभव", "mr": "कायदेशीर कारवाई शक्य"},
      {"title": "Revenge Porn", "en": "Strict punishment", "hi": "कड़ी सजा", "mr": "कडक शिक्षा"},
      {"title": "Identity Theft", "en": "Punishable under IT Act", "hi": "आईटी एक्ट के तहत सजा", "mr": "आयटी कायद्यांतर्गत शिक्षा"},
    ],

    "🚨 Government Support & Helplines": [
      {"title": "112", "en": "Emergency helpline", "hi": "आपातकालीन सेवा", "mr": "आपत्कालीन सेवा"},
      {"title": "1091", "en": "Women police helpline", "hi": "महिला हेल्पलाइन", "mr": "महिला हेल्पलाईन"},
      {"title": "181", "en": "Women distress helpline", "hi": "महिला सहायता हेल्पलाइन", "mr": "महिला सहाय्य हेल्पलाईन"},
      {"title": "One Stop Centre", "en": "Legal + medical + counseling support", "hi": "कानूनी, चिकित्सा और काउंसलिंग सहायता", "mr": "कायदेशीर, वैद्यकीय व समुपदेशन मदत"},
      {"title": "Mahila Police Volunteers", "en": "Local support system", "hi": "स्थानीय सहायता प्रणाली", "mr": "स्थानिक सहाय्य प्रणाली"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final _ = LangInherited.of(context).lang;

    return Scaffold(
      appBar: AppBar(title: Text(AppText.get(context, "women"))),
      body: ListView(
        children: rights.entries.map((category) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            child: ExpansionTile(
              title: Text(
                category.key,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: category.value.map((item) {
                return ListTile(
                      title: Text(item["title"]!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("EN: ${item["en"]}"),
                          Text("HI: ${item["hi"]}"),
                          Text("MR: ${item["mr"]}"),
                        ],
                      ),

                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
class MenLegalRights extends StatelessWidget {

  final Map<String, List<Map<String, String>>> rights = {

    "🔷 Fundamental Rights": [
      {
        "title": "Article 14",
        "en": "Equality before law",
        "hi": "कानून के समक्ष समानता",
        "mr": "कायद्यापुढे समानता"
      },
      {
        "title": "Article 21",
        "en": "Right to life and personal liberty",
        "hi": "जीवन और व्यक्तिगत स्वतंत्रता का अधिकार",
        "mr": "जीवन आणि वैयक्तिक स्वातंत्र्याचा अधिकार"
      },
    ],

    "⚖️ Protection Against False Cases": [
      {
        "title": "False Allegations",
        "en": "You have the right to defend against false accusations",
        "hi": "झूठे आरोपों के खिलाफ बचाव का अधिकार",
        "mr": "खोट्या आरोपांपासून संरक्षणाचा अधिकार"
      },
      {
        "title": "Defamation Law",
        "en": "You can file a defamation case for false claims",
        "hi": "झूठे आरोपों पर मानहानि का केस कर सकते हैं",
        "mr": "खोट्या आरोपांवर मानहानीचा दावा करू शकता"
      },
    ],

    "🏠 Domestic Violence (Men)": [
      {
        "title": "Emotional & Physical Abuse",
        "en": "Men can also report domestic abuse",
        "hi": "पुरुष भी घरेलू हिंसा की शिकायत कर सकते हैं",
        "mr": "पुरुषही घरगुती हिंसेची तक्रार करू शकतात"
      },
      {
        "title": "Legal Support",
        "en": "You can approach court for protection",
        "hi": "आप अदालत से सुरक्षा मांग सकते हैं",
        "mr": "तुम्ही न्यायालयाकडून संरक्षण मागू शकता"
      },
    ],

    "👨‍⚖️ Marriage & Divorce Rights": [
      {
        "title": "Right to Divorce",
        "en": "Men have legal right to seek divorce",
        "hi": "पुरुषों को तलाक लेने का अधिकार है",
        "mr": "पुरुषांना घटस्फोट घेण्याचा अधिकार आहे"
      },
      {
        "title": "Child Custody",
        "en": "Men can apply for child custody",
        "hi": "पुरुष बच्चों की कस्टडी मांग सकते हैं",
        "mr": "पुरुष मुलांच्या ताब्यासाठी अर्ज करू शकतात"
      },
      {
        "title": "Maintenance Rights",
        "en": "Court decides fair financial responsibilities",
        "hi": "अदालत आर्थिक जिम्मेदारी तय करती है",
        "mr": "न्यायालय आर्थिक जबाबदारी ठरवते"
      },
    ],

    "🏡 Property Rights": [
      {
        "title": "Property Ownership",
        "en": "Men have equal property ownership rights",
        "hi": "पुरुषों को संपत्ति का समान अधिकार है",
        "mr": "पुरुषांना मालमत्तेवर समान हक्क आहे"
      },
      {
        "title": "Inheritance Rights",
        "en": "Right to inherit family property",
        "hi": "पारिवारिक संपत्ति में अधिकार",
        "mr": "कौटुंबिक मालमत्तेवर हक्क"
      },
    ],

    "💼 Workplace Rights": [
      {
        "title": "Equal Pay",
        "en": "Men also have right to fair wages",
        "hi": "पुरुषों को भी उचित वेतन का अधिकार है",
        "mr": "पुरुषांनाही योग्य वेतनाचा अधिकार आहे"
      },
      {
        "title": "Workplace Harassment",
        "en": "Men can report harassment at workplace",
        "hi": "पुरुष भी कार्यस्थल पर शिकायत कर सकते हैं",
        "mr": "पुरुषही कामाच्या ठिकाणी तक्रार करू शकतात"
      },
    ],

    "💻 Cyber Safety": [
      {
        "title": "Online Abuse",
        "en": "Men are protected from cyber harassment",
        "hi": "पुरुष ऑनलाइन उत्पीड़न से सुरक्षित हैं",
        "mr": "पुरुष सायबर छळापासून सुरक्षित आहेत"
      },
      {
        "title": "Identity Theft",
        "en": "You can report identity theft legally",
        "hi": "पहचान चोरी की शिकायत कर सकते हैं",
        "mr": "ओळख चोरीची तक्रार करू शकता"
      },
    ],

    "🚨 Legal Help & Support": [
      {
        "title": "Legal Aid",
        "en": "Free legal aid is available",
        "hi": "मुफ्त कानूनी सहायता उपलब्ध है",
        "mr": "मोफत कायदेशीर मदत उपलब्ध आहे"
      },
      {
        "title": "Police Complaint",
        "en": "You can file complaint at any police station",
        "hi": "किसी भी थाने में शिकायत कर सकते हैं",
        "mr": "कोणत्याही पोलिस ठाण्यात तक्रार करू शकता"
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final _ = LangInherited.of(context).lang;

    return Scaffold(
      appBar: AppBar(title: Text(AppText.get(context, "men"))),

      body: ListView(
        children: rights.entries.map((entry) {
          return ExpansionTile(
            title: Text(
              entry.key,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: entry.value.map((item) {
              return ListTile(
                title: Text(item["title"]!),
                subtitle: Text(
                  "${item["en"]}\n${item["hi"]}\n${item["mr"]}",
                  style: TextStyle(height: 1.5),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 ADVANCED AI LEGAL ASSISTANT (COMPLETE)
////////////////////////////////////////////////////////////

class AIAssistant extends StatefulWidget {
  const AIAssistant({super.key});

  @override
  _AIAssistantState createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> {

  TextEditingController controller = TextEditingController();
  String response = "";

  /// 🧠 LEGAL KNOWLEDGE BASE
  final Map<String, Map<String, dynamic>> legalDB = {

    "rape_threat": {
      "keywords": ["rape threat", "threat", "kill threat", "force", "threaten"],
      "title": "⚠️ RAPE / VIOLENCE THREAT",
      "law": ["IPC 503", "IPC 506", "IPC 354D"],
      "actions": [
        "Do NOT ignore the threat",
        "Save messages / screenshots",
        "Inform trusted person immediately",
        "File police complaint (Zero FIR allowed)"
      ],
      "helpline": ["1091", "112"]
    },

    "rape": {
      "keywords": ["rape", "assault", "forced", "sexual assault"],
      "title": "🚨 SEXUAL ASSAULT",
      "law": ["IPC 376", "IPC 376D"],
      "actions": [
        "Go to safe place immediately",
        "Do NOT wash or change clothes",
        "Visit hospital (free treatment)",
        "Report to police"
      ],
      "helpline": ["112"]
    },

    "salary": {
      "keywords": ["salary", "less pay", "unequal pay", "equal work"],
      "title": "💼 SALARY DISCRIMINATION",
      "law": ["Equal Remuneration Act", "Article 39(d)"],
      "actions": [
        "Raise complaint to HR",
        "Collect salary slips as proof",
        "Approach labour court if unresolved"
      ],
      "helpline": []
    },

    "harassment": {
      "keywords": ["harassment", "boss", "office", "manager", "molest"],
      "title": "⚖️ WORKPLACE HARASSMENT",
      "law": ["POSH Act 2013", "IPC 354A"],
      "actions": [
        "Report to Internal Complaints Committee",
        "Keep evidence (emails/messages)",
        "File complaint within 3 months"
      ],
      "helpline": []
    },

    "domestic": {
      "keywords": ["husband", "violence", "family", "beating", "abuse"],
      "title": "🏠 DOMESTIC VIOLENCE",
      "law": ["Domestic Violence Act 2005", "IPC 498A"],
      "actions": [
        "Call 181 helpline",
        "File complaint",
        "Seek protection order",
        "Ask for financial support"
      ],
      "helpline": ["181"]
    },

    "cyber": {
      "keywords": ["online", "instagram", "cyber", "stalking", "social media"],
      "title": "💻 CYBER CRIME",
      "law": ["IT Act", "IPC 354D"],
      "actions": [
        "Take screenshots as evidence",
        "Report on cybercrime.gov.in",
        "Block offender"
      ],
      "helpline": []
    },

    "police": {
      "keywords": ["police", "fir", "complaint", "station"],
      "title": "👮 POLICE RIGHTS",
      "law": ["CrPC Rights"],
      "actions": [
        "You can file Zero FIR anywhere",
        "Ask for FIR copy",
        "Demand female officer"
      ],
      "helpline": []
    },
    "false_case": {
      "keywords": ["false case", "fake case", "wrong allegation", "misuse law"],
      "title": "⚠️ FALSE CASE / MISUSE OF LAW",
      "law": ["IPC 182", "IPC 211", "Defamation Law"],
      "actions": [
        "Collect all evidence proving innocence",
        "File counter complaint",
        "Consult a lawyer immediately",
        "Apply for anticipatory bail if needed"
      ],
      "helpline": []
    },
    "divorce": {
      "keywords": ["divorce", "separation", "breakup", "custody"],
      "title": "👩‍⚖️ DIVORCE & FAMILY DISPUTE",
      "law": ["Hindu Marriage Act", "Family Court Laws"],
      "actions": [
        "Consult family court lawyer",
        "File petition for divorce",
        "Discuss child custody legally",
        "Maintain proper documentation"
      ],
      "helpline": []
    },
    "mental_abuse": {
      "keywords": ["mental torture", "mental harassment", "pressure", "stress"],
      "title": "🧠 MENTAL HARASSMENT",
      "law": ["IPC 498A (if applicable)", "Mental Harassment Laws"],
      "actions": [
        "Keep proof (messages, recordings)",
        "Talk to trusted person",
        "Seek legal advice",
        "File complaint if severe"
      ],
      "helpline": []
    },
    "forced_marriage": {
      "keywords": ["forced marriage", "family pressure", "marry forcefully"],
      "title": "🚫 FORCED MARRIAGE",
      "law": ["Right to Freedom (Article 21)"],
      "actions": [
        "You have right to refuse marriage",
        "Inform police or NGO",
        "Seek legal protection",
        "Contact helpline immediately"
      ],
      "helpline": ["1091", "112"]
    },
    "blackmail": {
      "keywords": ["blackmail", "threat photos", "private video", "leak"],
      "title": "🚨 BLACKMAIL / PRIVATE CONTENT THREAT",
      "law": ["IT Act", "IPC 354C", "IPC 503"],
      "actions": [
        "Do NOT panic or pay money",
        "Save all proof",
        "Report to cybercrime.gov.in",
        "File police complaint"
      ],
      "helpline": ["112"]
    },
    "police_refuse": {
      "keywords": ["police not helping", "refuse fir", "police denied"],
      "title": "👮 POLICE REFUSAL",
      "law": ["Right to Zero FIR", "CrPC Rights"],
      "actions": [
        "Go to another police station",
        "File Zero FIR",
        "Complain to SP office",
        "Send complaint via email"
      ],
      "helpline": []
    },
    "fake_profile": {
      "keywords": ["fake account", "fake profile", "impersonation"],
      "title": "💻 FAKE SOCIAL MEDIA PROFILE",
      "law": ["IT Act", "Identity Theft Laws"],
      "actions": [
        "Report account on platform",
        "Take screenshots",
        "File cyber complaint",
        "Inform police if serious"
      ],
      "helpline": []
    }
  };

  /// 🔥 AI ENGINE
  String analyze(String input) {
    input = input.toLowerCase();
    List<String> finalResponse = [];

    legalDB.forEach((key, data) {

      List keywords = data["keywords"];

      for (var word in keywords) {
        if (input.contains(word)) {

          String section = """
${data["title"]}

⚖️ LAWS:
${(data["law"] as List).map((e) => "- $e").join("\n")}

📌 ACTIONS:
${(data["actions"] as List).map((e) => "- $e").join("\n")}
""";

          if ((data["helpline"] as List).isNotEmpty) {
            section += "\n📞 HELPLINES: ${(data["helpline"] as List).join(", ")}";
          }

          finalResponse.add(section);
          break;
        }
      }
    });

    /// 🛡️ SMART FALLBACK (ALWAYS USEFUL)
    if (finalResponse.isEmpty) {
      return """
🛡️ GENERAL SAFETY GUIDANCE

Your situation may still be legally important.

✔ Stay in a safe place  
✔ Inform a trusted person  
✔ Save any evidence  

📞 Emergency: 112  
📞 Women Helpline: 1091  

👉 Try describing your issue with words like:
"salary", "office", "harassment", "threat", "online"
""";
    }

    return finalResponse.join("\n\n");
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Legal Assistant")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Describe your situation...",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  response = analyze(controller.text);
                });
              },
              child: Text("Analyze"),
            ),

            SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  response,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}