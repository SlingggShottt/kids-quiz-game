import '../models/question.dart';
import '../models/category.dart';

final List<Category> categories = [
  Category(
    name: 'Fruits',
    icon: '🍎',
    questions: [
      Question(
        imageName: 'apple',
        correctAnswer: 'Apple',
        options: ['Apple', 'Banana', 'Orange', 'Grape'],
      ),
      Question(
        imageName: 'banana',
        correctAnswer: 'Banana',
        options: ['Mango', 'Banana', 'Kiwi', 'Papaya'],
      ),
      Question(
        imageName: 'orange',
        correctAnswer: 'Orange',
        options: ['Lemon', 'Orange', 'Lime', 'Peach'],
      ),
      Question(
        imageName: 'grape',
        correctAnswer: 'Grape',
        options: ['Grape', 'Cherry', 'Blueberry', 'Strawberry'],
      ),
      Question(
        imageName: 'mango',
        correctAnswer: 'Mango',
        options: ['Mango', 'Papaya', 'Guava', 'Peach'],
      ),
      Question(
        imageName: 'strawberry',
        correctAnswer: 'Strawberry',
        options: ['Raspberry', 'Strawberry', 'Cherry', 'Cranberry'],
      ),
      Question(
        imageName: 'watermelon',
        correctAnswer: 'Watermelon',
        options: ['Watermelon', 'Cantaloupe', 'Honeydew', 'Pumpkin'],
      ),
      Question(
        imageName: 'pineapple',
        correctAnswer: 'Pineapple',
        options: ['Pineapple', 'Coconut', 'Passion Fruit', 'Dragon Fruit'],
      ),
      Question(
        imageName: 'cherry',
        correctAnswer: 'Cherry',
        options: ['Cherry', 'Grape', 'Blueberry', 'Raspberry'],
      ),
      Question(
        imageName: 'lemon',
        correctAnswer: 'Lemon',
        options: ['Lemon', 'Orange', 'Lime', 'Grapefruit'],
      ),
    ],
  ),
  Category(
    name: 'Vegetables',
    icon: '🥕',
    questions: [
      Question(
        imageName: 'carrot',
        correctAnswer: 'Carrot',
        options: ['Carrot', 'Radish', 'Potato', 'Ginger'],
      ),
      Question(
        imageName: 'tomato',
        correctAnswer: 'Tomato',
        options: ['Tomato', 'Chili', 'Bell Pepper', 'Eggplant'],
      ),
      Question(
        imageName: 'broccoli',
        correctAnswer: 'Broccoli',
        options: ['Broccoli', 'Cauliflower', 'Cabbage', 'Lettuce'],
      ),
      Question(
        imageName: 'corn',
        correctAnswer: 'Corn',
        options: ['Corn', 'Wheat', 'Rice', 'Barley'],
      ),
      Question(
        imageName: 'potato',
        correctAnswer: 'Potato',
        options: ['Potato', 'Sweet Potato', 'Yam', 'Turnip'],
      ),
      Question(
        imageName: 'onion',
        correctAnswer: 'Onion',
        options: ['Onion', 'Garlic', 'Leek', 'Shallot'],
      ),
      Question(
        imageName: 'cucumber',
        correctAnswer: 'Cucumber',
        options: ['Cucumber', 'Zucchini', 'Pickle', 'Bottle Gourd'],
      ),
      Question(
        imageName: 'pepper',
        correctAnswer: 'Bell Pepper',
        options: ['Bell Pepper', 'Chili', 'Jalapeno', 'Poblano'],
      ),
      Question(
        imageName: 'lettuce',
        correctAnswer: 'Lettuce',
        options: ['Lettuce', 'Spinach', 'Kale', 'Cabbage'],
      ),
      Question(
        imageName: 'eggplant',
        correctAnswer: 'Eggplant',
        options: ['Eggplant', 'Zucchini', 'Bitter Gourd', 'Squash'],
      ),
    ],
  ),
  Category(
    name: 'Vehicles',
    icon: '🚗',
    questions: [
      Question(
        imageName: 'car',
        correctAnswer: 'Car',
        options: ['Car', 'Truck', 'Bus', 'Van'],
      ),
      Question(
        imageName: 'bus',
        correctAnswer: 'Bus',
        options: ['Train', 'Bus', 'Tram', 'Trolley'],
      ),
      Question(
        imageName: 'bicycle',
        correctAnswer: 'Bicycle',
        options: ['Bicycle', 'Motorcycle', 'Scooter', 'Tricycle'],
      ),
      Question(
        imageName: 'airplane',
        correctAnswer: 'Airplane',
        options: ['Airplane', 'Helicopter', 'Rocket', 'Glider'],
      ),
      Question(
        imageName: 'train',
        correctAnswer: 'Train',
        options: ['Train', 'Bus', 'Tram', 'Subway'],
      ),
      Question(
        imageName: 'boat',
        correctAnswer: 'Boat',
        options: ['Boat', 'Ship', 'Sailboat', 'Yacht'],
      ),
      Question(
        imageName: 'helicopter',
        correctAnswer: 'Helicopter',
        options: ['Helicopter', 'Airplane', 'Drone', 'Blimp'],
      ),
      Question(
        imageName: 'truck',
        correctAnswer: 'Truck',
        options: ['Truck', 'Car', 'Van', 'Bus'],
      ),
      Question(
        imageName: 'motorcycle',
        correctAnswer: 'Motorcycle',
        options: ['Motorcycle', 'Bicycle', 'Scooter', 'ATV'],
      ),
      Question(
        imageName: 'ship',
        correctAnswer: 'Ship',
        options: ['Ship', 'Boat', 'Submarine', 'Cruise'],
      ),
    ],
  ),
  Category(
    name: 'Animals',
    icon: '🦁',
    questions: [
      Question(
        imageName: 'lion',
        correctAnswer: 'Lion',
        options: ['Lion', 'Tiger', 'Leopard', 'Cheetah'],
      ),
      Question(
        imageName: 'dog',
        correctAnswer: 'Dog',
        options: ['Dog', 'Wolf', 'Fox', 'Hyena'],
      ),
      Question(
        imageName: 'cat',
        correctAnswer: 'Cat',
        options: ['Cat', 'Tiger', 'Leopard', 'Panther'],
      ),
      Question(
        imageName: 'elephant',
        correctAnswer: 'Elephant',
        options: ['Elephant', 'Rhino', 'Hippo', 'Giraffe'],
      ),
      Question(
        imageName: 'monkey',
        correctAnswer: 'Monkey',
        options: ['Monkey', 'Gorilla', 'Chimp', 'Baboon'],
      ),
      Question(
        imageName: 'rabbit',
        correctAnswer: 'Rabbit',
        options: ['Rabbit', 'Hare', 'Bunny', 'Pika'],
      ),
      Question(
        imageName: 'bird',
        correctAnswer: 'Bird',
        options: ['Bird', 'Chicken', 'Duck', 'Swan'],
      ),
      Question(
        imageName: 'fish',
        correctAnswer: 'Fish',
        options: ['Fish', 'Dolphin', 'Whale', 'Shark'],
      ),
      Question(
        imageName: 'horse',
        correctAnswer: 'Horse',
        options: ['Horse', 'Donkey', 'Zebra', 'Pony'],
      ),
      Question(
        imageName: 'cow',
        correctAnswer: 'Cow',
        options: ['Cow', 'Buffalo', 'Ox', 'Bull'],
      ),
    ],
  ),
  Category(
    name: 'Colors',
    icon: '🎨',
    questions: [
      Question(
        imageName: 'red',
        correctAnswer: 'Red',
        options: ['Red', 'Pink', 'Orange', 'Maroon'],
      ),
      Question(
        imageName: 'blue',
        correctAnswer: 'Blue',
        options: ['Blue', 'Navy', 'Sky Blue', 'Cyan'],
      ),
      Question(
        imageName: 'yellow',
        correctAnswer: 'Yellow',
        options: ['Yellow', 'Gold', 'Lemon', 'Cream'],
      ),
      Question(
        imageName: 'green',
        correctAnswer: 'Green',
        options: ['Green', 'Lime', 'Olive', 'Mint'],
      ),
      Question(
        imageName: 'purple',
        correctAnswer: 'Purple',
        options: ['Purple', 'Violet', 'Lavender', 'Indigo'],
      ),
      Question(
        imageName: 'orange_color',
        correctAnswer: 'Orange',
        options: ['Orange', 'Peach', 'Apricot', 'Coral'],
      ),
      Question(
        imageName: 'pink',
        correctAnswer: 'Pink',
        options: ['Pink', 'Rose', 'Magenta', 'Coral'],
      ),
      Question(
        imageName: 'brown',
        correctAnswer: 'Brown',
        options: ['Brown', 'Tan', 'Chestnut', 'Chocolate'],
      ),
      Question(
        imageName: 'black',
        correctAnswer: 'Black',
        options: ['Black', 'Charcoal', 'Dark Gray', 'Ebony'],
      ),
      Question(
        imageName: 'white',
        correctAnswer: 'White',
        options: ['White', 'Ivory', 'Snow', 'Pearl'],
      ),
    ],
  ),
  Category(
    name: 'Shapes',
    icon: '⭐',
    questions: [
      Question(
        imageName: 'circle',
        correctAnswer: 'Circle',
        options: ['Circle', 'Oval', 'Ellipse', 'Sphere'],
      ),
      Question(
        imageName: 'square',
        correctAnswer: 'Square',
        options: ['Square', 'Rectangle', 'Cube', 'Diamond'],
      ),
      Question(
        imageName: 'triangle',
        correctAnswer: 'Triangle',
        options: ['Triangle', 'Pyramid', 'Cone', 'Arrow'],
      ),
      Question(
        imageName: 'star',
        correctAnswer: 'Star',
        options: ['Star', 'Pentagon', 'Hexagon', 'Asterisk'],
      ),
      Question(
        imageName: 'heart',
        correctAnswer: 'Heart',
        options: ['Heart', 'Diamond', 'Pear', 'Drop'],
      ),
      Question(
        imageName: 'rectangle',
        correctAnswer: 'Rectangle',
        options: ['Rectangle', 'Square', 'Parallelogram', 'Trapezoid'],
      ),
      Question(
        imageName: 'diamond',
        correctAnswer: 'Diamond',
        options: ['Diamond', 'Rhombus', 'Kite', 'Parallelogram'],
      ),
      Question(
        imageName: 'hexagon',
        correctAnswer: 'Hexagon',
        options: ['Hexagon', 'Octagon', 'Pentagon', 'Cube'],
      ),
      Question(
        imageName: 'pentagon',
        correctAnswer: 'Pentagon',
        options: ['Pentagon', 'Hexagon', 'House', 'Star'],
      ),
      Question(
        imageName: 'oval',
        correctAnswer: 'Oval',
        options: ['Oval', 'Ellipse', 'Circle', 'Egg'],
      ),
    ],
  ),
];
