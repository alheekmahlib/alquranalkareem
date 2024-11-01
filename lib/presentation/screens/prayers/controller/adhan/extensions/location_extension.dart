part of '../../../prayers.dart';

extension LocationExtension on String {
  Future<CalculationParameters> getCalculationParameters() async {
    final country = this.getCountry();
    final parameters = await getCalculationParametersFromJson(this);
    LocationEnum select = parameters?.getCountry() ?? country;

    switch (select) {
      case LocationEnum.umm_al_qura:
        return CalculationMethod.umm_al_qura.getParameters();
      case LocationEnum.NorthAmerica:
        return CalculationMethod.north_america.getParameters();
      case LocationEnum.Egyptian:
        return CalculationMethod.egyptian.getParameters();
      case LocationEnum.Dubai:
        return CalculationMethod.dubai.getParameters();
      case LocationEnum.Karachi:
        return CalculationMethod.karachi.getParameters();
      case LocationEnum.Kuwait:
        return CalculationMethod.kuwait.getParameters();
      case LocationEnum.Qatar:
        return CalculationMethod.qatar.getParameters();
      case LocationEnum.Turkey:
        return CalculationMethod.turkey.getParameters();
      case LocationEnum.Singapore:
        return CalculationMethod.singapore.getParameters();
      case LocationEnum.muslim_world_league:
        return CalculationMethod.muslim_world_league.getParameters();
      case LocationEnum.Other:
        return CalculationMethod.other.getParameters();
      default:
        throw Exception('Unknown location: $this');
    }
  }
}

Future<String?> getCalculationParametersFromJson(String countryName) async {
  try {
    final jsonString = await rootBundle.loadString('assets/json/madhab.json');
    final jsonData = jsonDecode(jsonString);
    final countryData =
        List<Map<String, dynamic>>.from(jsonData).firstWhereOrNull(
      (item) => item['country'] == countryName,
    );

    if (countryData == null) return null; // Handle missing country data

    // Create and return CalculationParameters object
    return countryData['params'];
  } catch (e) {
    print('Error fetching calculation parameters: $e');
    return null;
  }
}
