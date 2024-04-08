enum LocationEnum {
  NorthAmerica,
  Egyptian,
  Dubai,
  Karachi,
  Kuwait,
  Qatar,
  Turkey,
  Singapore,
  Tehran,
  Other,
}

extension LocationEnumExtension on String {
  LocationEnum getCountry() {
    switch (this.toLowerCase()) {
      case 'united states':
        return LocationEnum.NorthAmerica;
      case 'egypt':
        return LocationEnum.Egyptian;
      case 'united arab emirates':
        return LocationEnum.Dubai;
      case 'pakistan':
      case 'karachi':
        return LocationEnum.Karachi;
      case 'kuwait':
        return LocationEnum.Kuwait;
      case 'qatar':
        return LocationEnum.Qatar;
      case 'turkey':
        return LocationEnum.Turkey;
      case 'singapore':
        return LocationEnum.Singapore;
      case 'tehran':
        return LocationEnum.Tehran;
      default:
        return LocationEnum.Other;
    }
  }
}
