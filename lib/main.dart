import 'package:flutter/material.dart';
import 'api_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Yarche',
        theme: new ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const BottomNavigationContainer());
  }
}

class BottomNavigationContainer extends StatefulWidget {
  const BottomNavigationContainer();

  @override
  State<StatefulWidget> createState() => BottomNavigationContainerState();
}

class BottomNavigationContainerState extends State<BottomNavigationContainer> {
  final _bottomBarScreens = <Widget>[
    new ScopedModel(model: _CategoryListModel(), child: const CategoriesScreen()),
    const Center(child: const Text("Second"))
  ];
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: const Text("Yarche")),
      body: _bottomBarScreens[_selectedIndex],
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(title: const Text("First"), icon: const Icon(Icons.search)),
          new BottomNavigationBarItem(title: const Text("Second"), icon: const Icon(Icons.search))
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen();

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<_CategoryListModel>(builder: (context, child, model) {
      if (model.categories.isNotEmpty) {
        return CategoryList(categories: model.categories);
      }

      return const Center(child: const CircularProgressIndicator());
    });
  }
}

class CategoryList extends StatelessWidget {
  final List<Category> categories;

  CategoryList({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, index) {
        final category = categories[index];
        final dividerIndent = index == categories.length - 1 ? 0.0 : 16.0;

        return new Column(children: [
          new ListTile(
              leading: new Image.network(category.thumbnailUrl, fit: BoxFit.contain, width: 36.0, height: 36.0),
              title: new Text(category.name)),
          new Divider(
            height: 1.0,
            indent: dividerIndent,
          )
        ]);
      },
      itemCount: categories.length,
    );
  }
}

class _CategoryListModel extends Model {
  List<Category> categories = [];

  _CategoryListModel() {
    _fetchCategories();
  }

  _fetchCategories() async {
    categories = await CategoryService().fetchCategories()
    .catchError((error) {
      print(error);
    });
    notifyListeners();
  }
}