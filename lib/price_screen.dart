import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';
import 'networking.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  String btcExchangeRate, ethExchangeRate, ltcExchangeRate;

  void setExchangeRate() async {
    var btcValue =
        await getExchangeRate(crypto: 'BTC', currency: selectedCurrency);
    var ethValue =
        await getExchangeRate(crypto: 'ETH', currency: selectedCurrency);
    var ltcValue =
        await getExchangeRate(crypto: 'LTC', currency: selectedCurrency);
    setState(() {
      btcExchangeRate = btcValue;
      ethExchangeRate = ethValue;
      ltcExchangeRate = ltcValue;
    });
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        setExchangeRate();
      },
    );
  }

  CupertinoPicker iOSCupertinoPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(
          currency,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        setExchangeRate();
      },
      children: pickerItems,
    );
  }

  void initState() {
    super.initState();
    setExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              currencyChild(
                crypto: 'BTC',
                exchangeRate: btcExchangeRate ?? 'no data',
                selectedCurrency: selectedCurrency,
              ),
              currencyChild(
                crypto: 'ETH',
                exchangeRate: ethExchangeRate ?? 'no data',
                selectedCurrency: selectedCurrency,
              ),
              currencyChild(
                crypto: 'LTC',
                exchangeRate: ltcExchangeRate ?? 'no data',
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              bottom: 30.0,
            ),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSCupertinoPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
