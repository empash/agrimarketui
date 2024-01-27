class Constants {
  static const rootUrl = 'agrimarket-production.up.railway.app';

  static final List<String> servicesList = [
    'workers',
    'machines',
    'Seedlings',
    'seedlings',
    'advisor',
    'pesticides'
  ];

  static final List serviceStatus = [
    'hired',
    'cancelled',
    'operating',
  ];

  static final List salesStatus = [
    'sold',
    'cancelled',
    'waiting',
  ];

  static final Map<String, List<String>> monthlyCrops = {
    'January': ['Kale', 'Carrots', 'Leeks', 'Parsnips', 'Turnips'],
    'February': ['Spinach', 'Beets', 'Lettuce', 'Radishes', 'Cabbage'],
    'March': ['Peas', 'Broccoli', 'Cabbage', 'Onions', 'Lettuce', 'Kohlrabi'],
    'April': ['Strawberries', 'Asparagus', 'Lettuce', 'Carrots', 'Spinach'],
    'May': ['Tomatoes', 'Cucumbers', 'Peppers', 'Zucchini', 'Melons', 'Basil'],
    'June': [
      'Corn',
      'Green Beans',
      'Watermelon',
      'Basil',
      'Cilantro',
      'Cantaloupe'
    ],
    'July': [
      'Blueberries',
      'Tomatoes',
      'Bell Peppers',
      'Eggplant',
      'Okra',
      'Peaches'
    ],
    'August': [
      'Cucumbers',
      'Tomatoes',
      'Zucchini',
      'Melons',
      'Basil',
      'Rosemary'
    ],
    'September': [
      'Pumpkins',
      'Apples',
      'Cauliflower',
      'Kale',
      'Brussels Sprouts',
      'Rutabaga'
    ],
    'October': [
      'Brussels Sprouts',
      'Beets',
      'Cabbage',
      'Carrots',
      'Turnips',
      'Radishes'
    ],
    'November': [
      'Potatoes',
      'Winter Squash',
      'Onions',
      'Garlic',
      'Lettuce',
      'Spinach'
    ],
    'December': [
      'Collard Greens',
      'Turnips',
      'Carrots',
      'Potatoes',
      'Kale',
      'Arugula'
    ],
  };

  static final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}
