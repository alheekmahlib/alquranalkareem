enum LocationEnum {
  umm_al_qura,
  NorthAmerica,
  Egyptian,
  Dubai,
  Karachi,
  Kuwait,
  Qatar,
  Turkey,
  Singapore,
  muslim_world_league,
  Other,
}

extension LocationEnumExtension on String {
  LocationEnum getCountry() {
    switch (this.toLowerCase()) {
      case 'Saudi Arabia':
        return LocationEnum.umm_al_qura;
      case 'united states':
        return LocationEnum.NorthAmerica;
      case 'egypt':
        return LocationEnum.Egyptian;
      case 'united arab emirates':
        return LocationEnum.Dubai;
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
      default:
        return LocationEnum.Other;
    }
  }
}
