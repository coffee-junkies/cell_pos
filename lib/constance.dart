import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'class/laundry_service.dart';

TextStyle kLoginText = const TextStyle(
  fontSize: 25
);

enum KItemEnums {items, categories, discounts}

late Box boxCustomer;
late Box boxReceipt;

List<String> kCategories = ["All", "Full-Service", "Partial-Service", "Commodities"];
List<LaundryService> kLaundryServicesFull = [

  LaundryService(unit: "Load", category: "Full-Service", service: "Assorted", price: 200),
  LaundryService(unit: "Load", category: "Full-Service", service: "Blankets", price: 210),
  LaundryService(unit: "Load", category: "Full-Service", service: "Comforters & Duvet", price: 220),
  LaundryService(unit: "Load", category: "Full-Service", service: "Heavy Soiled", price: 240),
];
List<LaundryService> kLaundryServicesPartial = [
  LaundryService(unit: "Load", category: "Partial-Service", service: "Wash", price: 80),
  LaundryService(unit: "Load", category: "Partial-Service", service: "Dry", price: 80),
  LaundryService(unit: "Load", category: "Partial-Service", service: "Fold", price: 35),
  LaundryService(unit: "Load", category: "Partial-Service", service: "Tumble-Dry", price: 20),
  LaundryService(unit: "Load", category: "Partial-Service", service: "Spin-Dry", price: 20),
];
List<LaundryService> kLaundryServicesCommodities = [
  LaundryService(unit: "Pcs", category: "Commodities", service: "Downy-Passion", price: 10),
  LaundryService(unit: "Pcs", category: "Commodities", service: "Downy-Mystic", price: 10),
  LaundryService(unit: "Pcs", category: "Commodities", service: "Downy-Sunrise Fresh", price: 7.5),
  LaundryService(unit: "Pcs", category: "Commodities", service: "Tide", price: 10),
  LaundryService(unit: "Pcs", category: "Commodities", service: "Breeze", price: 10),
  LaundryService(unit: "Pcs", category: "Commodities", service: "Bleach", price: 10),
];