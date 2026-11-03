
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Google Mobile Ads
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdMob Interstitial',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ID de prueba oficial para Android
  final String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? interstitialAd;

  bool isAdLoaded = false;

  String message = 'Carga un anuncio para comenzar';

  // Cargar anuncio intersticial
  void loadInterstitialAd() {

    setState(() {
      message = 'Cargando anuncio...';
      isAdLoaded = false;
    });

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),

      adLoadCallback: InterstitialAdLoadCallback(

        onAdLoaded: (InterstitialAd ad) {

          interstitialAd = ad;

          setState(() {
            isAdLoaded = true;
            message = 'Anuncio cargado correctamente';
          });

          debugPrint('Anuncio cargado');
        },

        onAdFailedToLoad: (LoadAdError error) {

          debugPrint('Error al cargar anuncio: $error');

          setState(() {
            isAdLoaded = false;
            message = 'No se pudo cargar el anuncio';
          });
        },
      ),
    );
  }

  // Mostrar anuncio
  void showInterstitialAd() {

    if (interstitialAd == null) {

      setState(() {
        message = 'Primero debes cargar un anuncio';
      });

      return;
    }

    final ad = interstitialAd!;

    interstitialAd = null;
    isAdLoaded = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(

      onAdShowedFullScreenContent: (ad) {

        debugPrint('Anuncio mostrado');
      },

      onAdDismissedFullScreenContent: (ad) {

        debugPrint('Anuncio cerrado');

        ad.dispose();

        setState(() {
          message = 'Anuncio cerrado. Puedes cargar otro.';
        });
      },

      onAdFailedToShowFullScreenContent: (ad, error) {

        debugPrint('Error al mostrar anuncio: $error');

        ad.dispose();

        setState(() {
          message = 'No se pudo mostrar el anuncio';
        });
      },
    );

    ad.show();
  }

  @override
  void dispose() {

    interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('AdMob Interstitial'),
        centerTitle: true,
      ),

      body: Center(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.ads_click,
                size: 80,
                color: Colors.teal,
              ),

              const SizedBox(height: 20),

              const Text(
                'Anuncios intersticiales',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              const Text(
                'Esta aplicación demuestra la integración '
                    'de anuncios intersticiales de Google AdMob.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Text(
                message,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(

                  onPressed: loadInterstitialAd,

                  icon: const Icon(Icons.download),

                  label: const Text('Cargar anuncio'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(

                  onPressed: isAdLoaded
                      ? showInterstitialAd
                      : null,

                  icon: const Icon(Icons.play_arrow),

                  label: const Text('Mostrar anuncio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
