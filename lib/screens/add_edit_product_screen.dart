import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = '/add_edit_product';

  const AddEditProductScreen({super.key});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  //Il nous faut un Controller pour gérer la prévisualisation de l'image
  final _imageUrlController = TextEditingController();
  //FocusNode pour pouvoir redessiner l'image
  final _imageUrlFocusNode = FocusNode();
  //Variable d'accès à l'état du Form
  final _form = GlobalKey<FormState>();

  //Variable représentant le Product en cours
  var _editedProduct = Product.base();

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //1
    //On associe un gestionnaire au champ de saisie de l'url
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Récupération du produit --> update
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null && productId.isNotEmpty) {
        //Modification du produit
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl; //obligatoire
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //
    //Important : éviter les fuites mémoire (memory leaks)
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  ///Méthode de sauvegarde du formulaire
  void _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      //== false) { --> isValid! === vous savez que cette variable n'est pas null
      return;
    }

    _form.currentState?.save(); //Sauvgarde du formulaire
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null && _editedProduct.id!.isNotEmpty) {
      //Update
      try {
        Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct);
      } catch (error) {
        developer.log(error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      //Nouveau produit (Add New Product)
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        developer.log(error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

    // developer.log(_editedProduct.toString(), name: 'AddEditProduct _saveForm');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add / Edit Product'), actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveForm,
        ),
      ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction:
                          TextInputAction.next, //Bouton bas-droit du clavier
                      onFieldSubmitted: (_) {
                        //Lorsque la valeur est saisie
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = _editedProduct.copyWith(title: value);
                      },
                    ),
                    TextFormField(
                      //Valeur intiale pour remplir le champ
                      initialValue: '${_editedProduct.price}',
                      // initialValue: _editedProduct.price.toString(),
                      //Style du champ de saise --> Material
                      decoration: const InputDecoration(labelText: 'Price'),
                      //Action réalisée par le bouton inf.droit du clavier
                      textInputAction: TextInputAction.next,
                      //Type de clavier pour saisir la donnée
                      keyboardType: TextInputType.number,
                      //Identifiant pour le focus ou le listener
                      focusNode: _priceFocusNode,
                      //onXXXX --> événement : après la saisie, changement de contrôle
                      onFieldSubmitted: (_) {
                        //Lorsque la valeur est saisie
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      //Appelée par form.validate()
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (value != null && double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (value != null && double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      //Appelée par form.save()
                      onSaved: (value) {
                        _editedProduct = _editedProduct.copyWith(
                            price: double.parse(value ?? '0'));
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value != null && value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct =
                            _editedProduct.copyWith(description: value);
                      },
                    ),
                    //Pour l'image : une vignette avec un champ de saisie (url)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
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
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please provide an image URL';
                              }
                              if (value != null &&
                                  !value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please provide a valid URL';
                              }
                              if (value != null &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct =
                                  _editedProduct.copyWith(imageUrl: value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
