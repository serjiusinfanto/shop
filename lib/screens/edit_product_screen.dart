import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _initValues = {};
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    //bool _isValid = Uri.parse(_imageUrlController.text).isAbsolute;
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https") ||
          !_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    print(_editedProduct.id);
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
        Navigator.of(context).pop();
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred!"),
            content: Text("Something went wrong!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Okay"),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: "Price",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field cannot be empty";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please Enter a value greater than 0";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field cannot be empty";
                          }
                          if (value.length < 10) {
                            return "Should be atleast 10 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter a URL")
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Image URL",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field cannot be empty";
                                }
                                bool _validUrl = Uri.parse(value).isAbsolute;

                                if (!_validUrl) {
                                  return "Invalid Image URL";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    isFavourite: _editedProduct.isFavourite);
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
