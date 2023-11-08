'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "c81b7cfa9999e8934c3b57be40a7eb3c",
"splash/img/light-2x.png": "1499fe5e157c08e6311a3d17b28ffb7a",
"splash/img/dark-4x.png": "ec1f3843b2f58135150d6de01b86a7ae",
"splash/img/light-3x.png": "4c4ef9e21a3ecb02eb8d2cafe3b8ca96",
"splash/img/dark-3x.png": "fa59f01f97061bfdc47a1af6bb150b70",
"splash/img/light-4x.png": "baef530a9f6b05ec3a65380f35702db1",
"splash/img/dark-2x.png": "d0f34198c9da29a5fcb606e627acc126",
"splash/img/dark-1x.png": "25b21142cc0bb35766213200131c699e",
"splash/img/light-1x.png": "beaea7aad06ad57d1bc2200b09567cda",
"index.html": "626f6c0ff31ab624783efab159277cb4",
"/": "626f6c0ff31ab624783efab159277cb4",
"main.dart.js": "976f369a81c793b8747555ebdd3a8953",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "d419b53fc4247fed75ccd452298008ce",
"icons/Icon-192.png": "2eeacf6fa825cd9ea195fa3a24d927d7",
"icons/Icon-maskable-192.png": "2eeacf6fa825cd9ea195fa3a24d927d7",
"icons/Icon-maskable-512.png": "be86d6c50ae79a034365bf53beffb18f",
"icons/Icon-512.png": "be86d6c50ae79a034365bf53beffb18f",
"manifest.json": "7fe9cef8c5147bbcd7a8f3d646674f5a",
"assets/AssetManifest.json": "f3b4836d0135597b5a62cd3c1d49f3c6",
"assets/NOTICES": "ee3b00edcd4de6c4e45c8878d47a9392",
"assets/FontManifest.json": "c878c178ef96c4beaecd8d0cf1ab412e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "7bc443ac77834c5e3087756940b3a967",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "c3543f2770e87d93deeab1f60285f589",
"assets/fonts/MaterialIcons-Regular.otf": "0787d28123d214c51977612122e59d89",
"assets/assets/svg/surah_na.svg": "3323e0da6cc16576d9d1003026b490bd",
"assets/assets/svg/splash_icon.svg": "d73a31f3711f3451053872d1945ad0a3",
"assets/assets/svg/surah_name/0016.svg": "aad30645fc6ffbb130e8c7c512a3d033",
"assets/assets/svg/surah_name/0017.svg": "473ec0615843b19a5138290a51c9a7b9",
"assets/assets/svg/surah_name/0029.svg": "bf727966957b0720dd89ae6babfe929a",
"assets/assets/svg/surah_name/0015.svg": "0f3a9a9366168ef944a91d8eb2c0f1aa",
"assets/assets/svg/surah_name/0014.svg": "eb7b5f570ca84d8c12ee235b279f74f4",
"assets/assets/svg/surah_name/0028.svg": "585cd08b11d1c74ed824f625e3635bed",
"assets/assets/svg/surah_name/0010.svg": "6d1d17c32bf20faa3fcb3e807b414253",
"assets/assets/svg/surah_name/0038.svg": "656535d4bd51405e34e15c18c4f34e03",
"assets/assets/svg/surah_name/0039.svg": "0dfc4853a77c80a3a2333a00b2c200ec",
"assets/assets/svg/surah_name/0011.svg": "776629fa94f035f2bf3a65190a3e4b58",
"assets/assets/svg/surah_name/0013.svg": "af066d734375a51a087bb6655b347ead",
"assets/assets/svg/surah_name/0012.svg": "8a2d6eff0584a87f3be768d3e088e3d0",
"assets/assets/svg/surah_name/0049.svg": "88b5b26bf7672ee6de889e21701a8051",
"assets/assets/svg/surah_name/0061.svg": "9c550da616cb8fa8f24cd3bb52c39d6e",
"assets/assets/svg/surah_name/0075.svg": "5c3d1d9aca53bc1893190d179b0c45be",
"assets/assets/svg/surah_name/006.svg": "84147e746e5470d704ba57356d191d68",
"assets/assets/svg/surah_name/007.svg": "980a8a3468ddbb02db29aab8b2d24596",
"assets/assets/svg/surah_name/0074.svg": "a5f01ca3f91d7feec27b4f5f598607e5",
"assets/assets/svg/surah_name/0060.svg": "5bb8c561cf8b78e2545d82c1419f5c5e",
"assets/assets/svg/surah_name/0048.svg": "d64cf990013af5522f7ab44ccf64bd14",
"assets/assets/svg/surah_name/0089.svg": "d0c85430e3cfac6f35fcd9e5f633d045",
"assets/assets/svg/surah_name/00109.svg": "731b60dbac4000d696b01102f5774c55",
"assets/assets/svg/surah_name/0076.svg": "f814d3983871dc40f098490f17dbd8dd",
"assets/assets/svg/surah_name/0062.svg": "705c91e7e17279df1f7ad243e09be34e",
"assets/assets/svg/surah_name/005.svg": "aa1f0807fdcf20f699c32dbede2043fb",
"assets/assets/svg/surah_name/004.svg": "0b8327516f58ba89677e303b4f529135",
"assets/assets/svg/surah_name/0063.svg": "798c022758a7b23778631a3478911d98",
"assets/assets/svg/surah_name/0077.svg": "022a8987975f8cf44e3415d0d2a79806",
"assets/assets/svg/surah_name/00108.svg": "23142d5869890b1f8c4458d9c09a5dc5",
"assets/assets/svg/surah_name/0088.svg": "e1a0497806e067375884a78053f5666f",
"assets/assets/svg/surah_name/0098.svg": "7bb9689b12ddbf9345a60b5692160c67",
"assets/assets/svg/surah_name/0073.svg": "00237fa6f43905df36729d624c07dfca",
"assets/assets/svg/surah_name/0067.svg": "2690c783b732a04b2b0241f4ee91d472",
"assets/assets/svg/surah_name/001.svg": "08c0b9fb7353f89385909fecfac5aa50",
"assets/assets/svg/surah_name/0066.svg": "92642c1475a4c1061b6bd790acfb3228",
"assets/assets/svg/surah_name/0072.svg": "aca789d56091e934dc4f7a42b3efc683",
"assets/assets/svg/surah_name/0099.svg": "b688b42ed288babc18c45d7c3396c84a",
"assets/assets/svg/surah_name/0064.svg": "08d3ded0fc1de000a29a69c196a22289",
"assets/assets/svg/surah_name/0070.svg": "bccb48d8df195e30362dcf19d6b05f65",
"assets/assets/svg/surah_name/0058.svg": "26a0a5f7a862fc4bd4602bb266292e3e",
"assets/assets/svg/surah_name/003.svg": "652468783f1fd550a8f7ea79e826dbac",
"assets/assets/svg/surah_name/002.svg": "2a8501be12411a972d2a08f9d00caced",
"assets/assets/svg/surah_name/0059.svg": "acfb4db2f130f0189cfa1103edcb361e",
"assets/assets/svg/surah_name/0071.svg": "7afaad91e1b6cc903e3718318288e04c",
"assets/assets/svg/surah_name/0065.svg": "b428a88ca0980db8b4c1ed4aa43dc5c6",
"assets/assets/svg/surah_name/0083.svg": "9d252b9da3b6d836bd580e45407cdd9b",
"assets/assets/svg/surah_name/0097.svg": "8d0b68a440fd027c6e0de1c8db62d042",
"assets/assets/svg/surah_name/0068.svg": "1ddfe8c7ba2b54972c795177f5b6b4ef",
"assets/assets/svg/surah_name/00103.svg": "d02ad3d9e3f9789b6583fce5ce27edac",
"assets/assets/svg/surah_name/0040.svg": "83ee9ece2b4fdb27d79e3d773ec1e6c9",
"assets/assets/svg/surah_name/0054.svg": "d255fa6ca05b647e56aa47a92d690c3a",
"assets/assets/svg/surah_name/0055.svg": "23890a95380ff45c782b3cf1895da463",
"assets/assets/svg/surah_name/0041.svg": "1616df4384219865d36ef2c938213b7a",
"assets/assets/svg/surah_name/00102.svg": "665459d6f0fb0e1682cad74a77120c82",
"assets/assets/svg/surah_name/0069.svg": "80987127b8adafc3e8d3ede59fd3c938",
"assets/assets/svg/surah_name/0096.svg": "9b7d01c169e01e0b3ba4908bf2f5945e",
"assets/assets/svg/surah_name/0082.svg": "a428a326a675e028183175e294f23f51",
"assets/assets/svg/surah_name/0094.svg": "30a3917ed3bc2889468cee80242b9e80",
"assets/assets/svg/surah_name/0080.svg": "9c05390cfcefc07a9fca435f51fde7e0",
"assets/assets/svg/surah_name/0057.svg": "4da882360103d8ab2234751f7dd4fa05",
"assets/assets/svg/surah_name/00114.svg": "b306ff29a0b1c81e9911908ba64eb239",
"assets/assets/svg/surah_name/00100.svg": "fbffe4e8b750565f49bb8a430e395e1d",
"assets/assets/svg/surah_name/0043.svg": "a90ae9de1ce97a5dc50866519aaf31c6",
"assets/assets/svg/surah_name/0042.svg": "76952261a8767b94a326e0e3f8dfb608",
"assets/assets/svg/surah_name/00101.svg": "10551d4bb31b871583f5e8068ea62ca9",
"assets/assets/svg/surah_name/0056.svg": "68c98d8bd9010ea6636a2a8b5cdd9427",
"assets/assets/svg/surah_name/0081.svg": "bbcab01cf7e564759a99cab2201198e1",
"assets/assets/svg/surah_name/0095.svg": "c07ce9d0f66d3c48bf231612a65ddb76",
"assets/assets/svg/surah_name/0091.svg": "dfdb20325f43a2857ad84b12c4d80dd9",
"assets/assets/svg/surah_name/0085.svg": "d093a04376465d0a801e1497169aa6f3",
"assets/assets/svg/surah_name/0052.svg": "67836d2512ef6366006f2bc5797a2bec",
"assets/assets/svg/surah_name/00111.svg": "f868b643b11211a5ac4b207abbb3385f",
"assets/assets/svg/surah_name/00105.svg": "578eca5fdc72d9d1a019ce4608d7fbfe",
"assets/assets/svg/surah_name/0046.svg": "54b6247d6f367f3b00276a4c3d46edf8",
"assets/assets/svg/surah_name/009.svg": "5bfd394372ad0d23f504183a8dafdda4",
"assets/assets/svg/surah_name/008.svg": "9132cd42af23b120c87ef398f0ce97ae",
"assets/assets/svg/surah_name/0047.svg": "b682f682187e132d202903e195b77c00",
"assets/assets/svg/surah_name/00104.svg": "9730770432f9c7ccedcedaca9ee2380b",
"assets/assets/svg/surah_name/00110.svg": "82d50946fc263c753a136dfa1d6204b5",
"assets/assets/svg/surah_name/0053.svg": "fb7dc58f725305881bbb68de5d7c0a28",
"assets/assets/svg/surah_name/0084.svg": "5790419b0fe86006a5150643ae251479",
"assets/assets/svg/surah_name/0090.svg": "1e5c5ae14071bea64a210349bf799aa0",
"assets/assets/svg/surah_name/0086.svg": "64bf9e32c2180171a56329e97dd54c81",
"assets/assets/svg/surah_name/0092.svg": "8e5b06699acdbf623737ca20607d12a7",
"assets/assets/svg/surah_name/00106.svg": "57e24128f3be9d4f9bf41292732573f9",
"assets/assets/svg/surah_name/0045.svg": "9410af13e3772a4e19dbd100f39d016d",
"assets/assets/svg/surah_name/0051.svg": "7c2609232383c83db08fafd69d157530",
"assets/assets/svg/surah_name/00112.svg": "7661715a45f86efd68cb768ad4eecac0",
"assets/assets/svg/surah_name/0079.svg": "f2531799b60a9947c72e825fa4f39dc1",
"assets/assets/svg/surah_name/0078.svg": "2ac402f8ae5539c9e4cf135a57cc1609",
"assets/assets/svg/surah_name/00113.svg": "0192b1630e4eb3f2d684ad395983e07b",
"assets/assets/svg/surah_name/0050.svg": "166e91262a2a0dc3b1727cf419140c1a",
"assets/assets/svg/surah_name/0044.svg": "612de60352012f9da89b23de67920386",
"assets/assets/svg/surah_name/00107.svg": "0d6acb107d9c2fd200b9fdd6f2dbef37",
"assets/assets/svg/surah_name/0093.svg": "839fda4dbe1b16d7690a7fb38387a7fa",
"assets/assets/svg/surah_name/0087.svg": "b0039ca65e1cdfa05ca4cfb63ea1470d",
"assets/assets/svg/surah_name/0023.svg": "38eac72a27ac78dfa6408a61814f39ed",
"assets/assets/svg/surah_name/0037.svg": "25608c7a1aaad923766317b00a3da9ab",
"assets/assets/svg/surah_name/0036.svg": "3e206111b1f336fd8a29ceac27e0d46b",
"assets/assets/svg/surah_name/0022.svg": "693e01f564abbb097ee1fbf258e2c9ef",
"assets/assets/svg/surah_name/0034.svg": "1798d6536d5479cf7dcf92b6d1e77714",
"assets/assets/svg/surah_name/0020.svg": "b0ab19081b1a917035ad1fb83611c1b9",
"assets/assets/svg/surah_name/0021.svg": "2597aa3ffb485be655417cf49c5fd012",
"assets/assets/svg/surah_name/0035.svg": "46fb73782024084240282dc8f17b9a6f",
"assets/assets/svg/surah_name/0031.svg": "be9c154af4399d1ee5bbaafeac1748c3",
"assets/assets/svg/surah_name/0025.svg": "a9e1081669e349d386791e0fdb680fc5",
"assets/assets/svg/surah_name/0019.svg": "829d2b3e4a8428bf6f60117b37f66317",
"assets/assets/svg/surah_name/0018.svg": "407e6639d1436bb024ba3585498307bd",
"assets/assets/svg/surah_name/0024.svg": "173c992f059af6b32a3a5d142f902589",
"assets/assets/svg/surah_name/0030.svg": "d56e2aafce879a89cd48b1213130e8c4",
"assets/assets/svg/surah_name/0026.svg": "5c2f37e816e0e488e2dd675807c2028e",
"assets/assets/svg/surah_name/0032.svg": "88d3b17d518cb36e472950e9f559e5d8",
"assets/assets/svg/surah_name/0033.svg": "aa326eaed722e28987bf9a0b38b88ba8",
"assets/assets/svg/surah_name/0027.svg": "f90afd8c726b755b872461f9c4e118c4",
"assets/assets/svg/hadith_icon.svg": "3cdf706234adfcc5079eec7ccd2b1c61",
"assets/assets/svg/zakhrafa.svg": "ddcc2af55f44ee5fe0e4a1768dbe7d86",
"assets/assets/svg/thegarlanded.svg": "742b04963250ea8df8c8f858afd34ecc",
"assets/assets/svg/athkar.svg": "763934570d1f6fbde07fd5d12bf6a183",
"assets/assets/svg/book.svg": "6a2e72b9150a2fa96af373402b207037",
"assets/assets/svg/menu_ic.svg": "1dfe0e1b88da1d2f5538fab7d544c35c",
"assets/assets/svg/Sorah_na_bg.svg": "88833cad77b5353c57da06356369e21a",
"assets/assets/svg/quran_ic.svg": "d97dd2183afa939d032bf628097e56cb",
"assets/assets/svg/hijri/10.svg": "bf5952e91d58e72053f7a391e4627dcc",
"assets/assets/svg/hijri/11.svg": "5e522d1d2b192b8c1c7ba936d2f34b33",
"assets/assets/svg/hijri/9.svg": "e53bccf5237890a696f3c7c0adc14edc",
"assets/assets/svg/hijri/8.svg": "28d10e1aecbf47c70e9704488219a513",
"assets/assets/svg/hijri/0.svg": "edbd416a6db88ac74f02287abdad8a2c",
"assets/assets/svg/hijri/1.svg": "f8736f9e8c7593681246f044e8d11d6d",
"assets/assets/svg/hijri/3.svg": "72accc7d141317f3d02d1f00373ebe4a",
"assets/assets/svg/hijri/2.svg": "e878fdb602fecf53a885037e156769f8",
"assets/assets/svg/hijri/6.svg": "bd19c42da9d2f41a48c1db03cd3df820",
"assets/assets/svg/hijri/7.svg": "b10ad5ee01970789288942908e8a4fe0",
"assets/assets/svg/hijri/5.svg": "fc1470e8ec8fbd303e82e2e5cb167de8",
"assets/assets/svg/hijri/4.svg": "a1e95b5b791e4312c67096373dad3112",
"assets/assets/svg/decorations.svg": "234def95546e1c0c0bed67cb8bae4f8a",
"assets/assets/svg/line2.svg": "c5511b53f1fc94f25577c07952167f08",
"assets/assets/svg/hijri_date.svg": "8978583329d79eef1c0c446aa4a39938",
"assets/assets/svg/azkar.svg": "4ad683726562dfb84137c15ac3124423",
"assets/assets/svg/tafseer_book.svg": "65e5997e4ddd84550a4b2c9e1e27fecc",
"assets/assets/svg/besmAllah.svg": "0cdde8ebcbbb475697b098c700e81464",
"assets/assets/svg/juz.svg": "430ce4cf7a543d056c761ec18626afd0",
"assets/assets/svg/line.svg": "3da9858a16bab2bcb89cbb6a94106da8",
"assets/assets/svg/sora_num.svg": "adf0068d05997bb1bf839c5683c56429",
"assets/assets/svg/space_line.svg": "5dc2e024bdc31097cdf8c4b522ca1295",
"assets/assets/svg/alheekmah_logo.svg": "051187c441538a5f659129743e58c816",
"assets/assets/svg/slider_ic.svg": "f72b09f2bed61a5838f7309567959e23",
"assets/assets/svg/juz/10.svg": "f16ef0c2a704d7512bdc75a7f2e01122",
"assets/assets/svg/juz/11.svg": "6ffe9b112c74b92671902ace1d6089c7",
"assets/assets/svg/juz/13.svg": "dc9e2267ce2617f2c819f50d452ccb2f",
"assets/assets/svg/juz/12.svg": "6f4de14c7e7c51d904a8f64f7da4785f",
"assets/assets/svg/juz/16.svg": "7bc51aea153fa99aeb3ac46f6168fe13",
"assets/assets/svg/juz/17.svg": "96030b7b7118a6dcff0d68d65bc7182a",
"assets/assets/svg/juz/15.svg": "3a9a1abc3a6275f02101fc2e3e82193e",
"assets/assets/svg/juz/29.svg": "f596769a384559b76281caae5400eb6a",
"assets/assets/svg/juz/28.svg": "b6b575a77a102069cc3e23fb4e8c21b5",
"assets/assets/svg/juz/14.svg": "9f18eb0f846ec6fc1dfc73f7182c98cd",
"assets/assets/svg/juz/9.svg": "f194805abd16278333114215331efe9a",
"assets/assets/svg/juz/8.svg": "67c8ec89a92fa7de3d847714afd4aad0",
"assets/assets/svg/juz/1.svg": "db2c688e37c23bd9eb2e79a94f3e664d",
"assets/assets/svg/juz/3.svg": "413ac74b193a3311b7f72c2fb2844c55",
"assets/assets/svg/juz/2.svg": "c76ff13a2c8558f45a4c00305512952d",
"assets/assets/svg/juz/6.svg": "85f0f2f240b47e74d729c7fe7207f9ad",
"assets/assets/svg/juz/7.svg": "3aecc58e73a70a77586267911356e7fc",
"assets/assets/svg/juz/5.svg": "0845233c7c100d300108cb6d5a9f6076",
"assets/assets/svg/juz/4.svg": "597758a9b906a098e9cb375f7c641ea4",
"assets/assets/svg/juz/19.svg": "11e79c368497e667cdd26c36e5f43b61",
"assets/assets/svg/juz/25.svg": "72355485101bb42577ca5d1e453c0851",
"assets/assets/svg/juz/24.svg": "9edf443c4ee261575443e92c4df20d31",
"assets/assets/svg/juz/30.svg": "13396e910ec02258e79c7fef25c8f1f7",
"assets/assets/svg/juz/18.svg": "c4ab6c162ac2ec083c60c8a243579938",
"assets/assets/svg/juz/26.svg": "51e194268b11e5e5063c6539f1e68b92",
"assets/assets/svg/juz/27.svg": "cd743a201a969b5688745993e755b835",
"assets/assets/svg/juz/23.svg": "6c25a3b8c811ba0d729e4da6e22c0b7b",
"assets/assets/svg/juz/22.svg": "a9cd657fc5403801c5431ec6284bd04b",
"assets/assets/svg/juz/20.svg": "47e2a1cc6a8c835b5fc6021773efdd6d",
"assets/assets/svg/juz/21.svg": "8d50c87488acda2790400167b5880aa2",
"assets/assets/svg/page_no_bg.svg": "9cee0e9628128fe63b063735f50187d1",
"assets/assets/svg/quran_te_ic.svg": "2c6f643260e831e8c8e5a0f3d2502ce8",
"assets/assets/locales/be.json": "c8429770a5afa1f352f7b754fb4e78d6",
"assets/assets/locales/en.json": "102e67658a51d5e873522b4701811bd8",
"assets/assets/locales/ar.json": "82c5e7d40e3fc2bc88396919b269e6bf",
"assets/assets/images/alheekmah_logo_dark.png": "c181aa64c2163aad61f5c3a5977166ab",
"assets/assets/images/Ghamadi.jpg": "fae07030f9cdedd4f1535cc29c5c8636",
"assets/assets/images/husary.jpg": "477232d1bb4b3e696391a201be01df3b",
"assets/assets/images/minshawy.jpg": "54f4fc67e6e92329cc0047b28499356d",
"assets/assets/images/app_gallery.png": "abba712010ebc33c4e75cf1ca6c34c74",
"assets/assets/images/ajamy.jpg": "e41445ea362dba04f29b093d6849c980",
"assets/assets/images/muaiqly.jpg": "3dc687a965236264109714a6495aeebc",
"assets/assets/images/alheekmah_logo.png": "9e0b2326d292b44f5c21bc89be424916",
"assets/assets/images/play_store.png": "b60e986c34325088d5be46648b3ba421",
"assets/assets/images/app_store.png": "ff5b05ed0187216471654dbb46e3ed3f",
"assets/assets/images/AlQuranAlKareem.jpg": "4ca960b462adcf309a63978374228e08",
"assets/assets/images/basit.jpg": "e8fd58fe7c8c25d28b63c4440b3eb164",
"assets/assets/json/translate/tr.json": "2a4320deb7189283fff45c8cfaae259e",
"assets/assets/json/translate/urdu.json": "ceb7303250564b4130c603d7f3809812",
"assets/assets/json/translate/ku.json": "3f908aed8e44849a7501c8f790cb02eb",
"assets/assets/json/translate/be.json": "2c7ae597b4accfeb1515c1e0afedd981",
"assets/assets/json/translate/en.json": "1415acb4e191f1c6ef0705f7ed4e2421",
"assets/assets/json/translate/in.json": "2f89d4e9c40dc72b3006cdfbca731bd0",
"assets/assets/json/translate/es.json": "06d08cbd1ae1a658b3c66f524aa6b089",
"assets/assets/json/translate/so.json": "2de6b6cdc3491a1e2275dcc1d6f9bc7b",
"assets/assets/json/quran.json": "ed9b66ac6ad6ad080184249f62123a50",
"assets/assets/lottie/search.json": "74776e1bc3d0c4674c96020d4cfe7702",
"assets/assets/lottie/loading.json": "ff74985e53cdcd9a0184e31996c18313",
"assets/assets/lottie/book.json": "b452daaa247b152d4d3eb8d00021c0a1",
"assets/assets/lottie/404.json": "4852236b8b80cd628f1b3140601b47ee",
"assets/assets/fonts/UthmanTN1_Ver10.otf": "7c0c99d532f135f63633578347912421",
"assets/assets/fonts/Kufam-VariableFont_wght.ttf": "91d90d45e45e2782b4d8c2dce70cde5f",
"assets/assets/fonts/Kufam-Italic-VariableFont_wght.ttf": "61c72e4df4a99164ab781e45aac6013b",
"assets/assets/fonts/UthmanicHafs_V20.ttf": "32397346c04c8b1dcc2476d9fccf05e4",
"assets/assets/fonts/Kufam-Regular.ttf": "552c74407616f42443ba1814761b9b3c",
"assets/assets/fonts/NotoNaskhArabic-VariableFont_wght.ttf": "ca8ba160f47026130c9d1804d914056f",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
