import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';

class FireStoreServices {
  // get user data
  static getUser(uid) {
    return firestore
        .collection(usersCollections)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // get products according to category

  static getProducts(category) {
    return firestore
        .collection(productsCollections)
        .where("p_category", isEqualTo: category)
        .snapshots();
  }

  static getSubCategoryProducts(title) {
    return firestore
        .collection(productsCollections)
        .where("p_subcategory", isEqualTo: title)
        .snapshots();
  }

  static Query getSubCategoryProductsQuery(String subcategory) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('p_subcategory', isEqualTo: subcategory);
  }

  // get cart

  static getCart(uid) {
    return firestore
        .collection(cartCollections)
        .where("added_by", isEqualTo: uid)
        .snapshots();
  }
  // delete document

  static deleteDocument(docId) {
    return firestore.collection(cartCollections).doc(docId).delete();
  }

  // get all chat messages

  static getChatMessages(docId) {
    return firestore
        .collection(chatCollections)
        .doc(docId)
        .collection(messageCollections)
        .orderBy("created_on", descending: false)
        .snapshots();
  }

  // get all orders

  static getAllOrders() {
    return firestore
        .collection(ordersCollections)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishlist() {
    return firestore
        .collection(productsCollections)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection(chatCollections)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollections)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollections)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollections)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      })
    ]);
    return res;
  }

  static allProducts() {
    return firestore.collection(productsCollections).snapshots();
  }

  static allSliders() {
    return firestore.collection("sliders").snapshots();
  }

  static getFeaturedProducts() {
    return firestore
        .collection(productsCollections)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  static searchProduct(title) {
    return firestore.collection(productsCollections).get();
  }
}
