import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../application.dart';
import '../../../utils/app_localizations.dart';
import '../../model/transaction_label.dart';
import '../../model/transaction_tag.dart';
import '../../model/transaction_tag_group.dart';
import '../../model/transaction_type.dart';
import '../../model/wallet.dart';

List<TransactionTagGroup> defaultTagGroups() {
  return [
    TransactionTagGroup(
      parent: 'Food & Drinks',
      children: [
        'Snack',
        'Dine Out',
        'Coffee',
        'Drinks',
        'Groceries',
      ],
    ),
    TransactionTagGroup(
      parent: 'Home',
      children: [
        'House Maintenance',
        'Utility Bills',
        'House Insurance',
      ],
    ),
    TransactionTagGroup(
      parent: 'Transport',
      children: [
        'Car Insurance',
        'Fuel',
        'Vehicle',
        'Parking',
      ],
    ),
  ];
}

List<TransactionTag> defaultTags() {
  return [
    // expenses
    // food
    TransactionTag(
      name: 'Food & Drinks',
      color: Colors.green.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.utensils)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Snack',
      color: const Color.fromARGB(255, 53, 1, 1).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.cookieBite)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Dine Out',
      color: Colors.red.shade200.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.pizzaSlice)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Coffee',
      color: Colors.brown.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.mugHot)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Drinks',
      color: Colors.pink.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.martiniGlass)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Groceries',
      color: Colors.blue.shade200.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.basketShopping)),
      type: TransactionType.expense,
    ),
    // home
    TransactionTag(
      name: 'Home',
      color: Colors.amber.shade900.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.house)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Rent',
      color: Colors.grey.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.houseUser)),
    ),
    TransactionTag(
      name: 'House Insurance',
      color: Colors.amber.shade600.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.houseMedicalFlag)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Utility Bills',
      color: const Color.fromARGB(255, 152, 154, 73).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.plug)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'House Maintenance',
      color: const Color.fromARGB(255, 119, 94, 41).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.screwdriverWrench)),
      type: TransactionType.expense,
    ),
    // transportation
    TransactionTag(
      name: 'Transport',
      color: const Color.fromARGB(255, 93, 93, 15).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.trainSubway)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Vehicle',
      color: Colors.lime.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.car)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Parking',
      color: Colors.blue.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.squareParking)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Fuel',
      color: Colors.black87.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.gasPump)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Car Insurance',
      color: Colors.lime.shade500.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.carBurst)),
      type: TransactionType.expense,
    ),
    // other
    TransactionTag(
      name: 'Health',
      color: Colors.green.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.stethoscope)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Clothes',
      color: Colors.teal.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.shirt)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Entertainment',
      color: Colors.pink.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.certificate)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Travel',
      color: Colors.green.shade300.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.mapLocationDot)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Education',
      color: const Color.fromARGB(255, 227, 144, 10).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.graduationCap)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Subscriptions',
      color: Colors.red.shade700.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.repeat)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Taxes',
      color: const Color.fromARGB(255, 56, 52, 52).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.fileInvoiceDollar)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Lifestyle',
      color: Colors.purple.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.solidStar)),
      type: TransactionType.expense,
    ),
    TransactionTag(
      name: 'Salary',
      color: Colors.indigo.shade800.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.moneyBills)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Pension',
      color: Colors.indigo.shade400.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.moneyBill)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Dividends',
      color: Colors.indigo.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.moneyBillTrendUp)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Personal Savings',
      color: const Color.fromARGB(255, 58, 65, 101).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.piggyBank)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Transfer',
      color: Colors.yellow.shade600.value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.rightLeft)),
    ),
    TransactionTag(
      name: 'Odd Jobs',
      color: const Color.fromARGB(255, 126, 73, 26).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.peopleCarryBox)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Investment',
      color: const Color.fromARGB(255, 182, 50, 107).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.fileInvoiceDollar)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Bonuses',
      color: const Color.fromARGB(255, 106, 119, 20).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.award)),
      type: TransactionType.income,
    ),
    TransactionTag(
      name: 'Commission',
      color: const Color.fromARGB(255, 94, 82, 95).value,
      icon: jsonEncode(serializeIcon(FontAwesomeIcons.percent)),
      type: TransactionType.income,
    ),
  ];
}

List<TransactionLabel> defaultLabels() {
  return [
    TransactionLabel(
      name: 'Vacation',
    ),
    TransactionLabel(
      name: 'School Expenses',
    ),
    TransactionLabel(
      name: 'Birthday ',
    ),
    TransactionLabel(
      name: 'Christmas Party',
    ),
  ];
}

Wallet dummyWallet() {
  return Wallet(
    ownerId: 0,
    name: 'Primary Wallet'.localized,
    description: 'This is my first wallet!'.localized,
    currency: Application.defaultCurrency,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );
}

TransactionTag dummyTag() {
  return TransactionTag(
    name: 'Other',
    color: Colors.grey.shade400.value,
    icon: jsonEncode(serializeIcon(FontAwesomeIcons.receipt)),
  );
}
