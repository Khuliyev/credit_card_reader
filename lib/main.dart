import 'package:emv_card_reader/card.dart';
import 'package:emv_card_reader/emv_card_reader.dart';
import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // NFC kart okuma instance
  final _emv = EmvCardReader();

  // Kart bilgilerini tutacak
  EmvCard? _card;

  @override
  void initState() {
    super.initState();
  }

  // NFC kart okuma fonksiyonu
  void _readCard() {
    // NFC adaptörü başlatılıyor
    _emv.start().then((_) {
      // Kartı dinle ve sonuçları al
      _emv.stream().listen((card) {
        setState(() {
          _card = card;  // Kart bilgilerini güncelle
        });

      });
    });
  }

  @override
  void dispose() {
    // NFC adaptörünü durdur
    _emv.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kart Okuyucu Uygulaması'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kart UI, eğer kart okunmadıysa boş bilgilerle gösterilecek.
              CreditCardUi(
                cardNumber: _card?.number ?? '**** **** **** ****',
                cardHolderFullName: _card?.holder ?? '',  // Kart sahibinin ismi
                validThru: _card?.expire ?? 'MM/YY',  // Kartın geçerlilik tarihi
                cvvNumber: '123',  // CVV'yi NFC ile okumadığınız için statik bir değer koyabilirsiniz.
                placeNfcIconAtTheEnd: true,
              ),
              SizedBox(height: 20),
              // NFC ile kart okutma butonu
              ElevatedButton(
                onPressed: _readCard,  // NFC kart okuma fonksiyonu
                child: Text('NFC ile Oku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
