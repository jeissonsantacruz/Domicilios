/* Flutter dependencies */
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suweb_domicilios/aplicacion/paginas/detalleShopper.dart';
import 'package:suweb_domicilios/arquitectura/preferenciasUsuario.dart';
import 'package:suweb_domicilios/arquitectura/proveedorUsuario.dart';
import 'package:suweb_domicilios/arquitectura/serviciosGestioncci.dart';
import 'package:suweb_domicilios/dominio/detalleProducto.dart';
import 'package:suweb_domicilios/dominio/dominio/picking_model.dart';


/*contiene la vista del historial de movimientos de un usario*/
class ShopperProductos extends StatefulWidget {
  final String idPedido;
  ShopperProductos({this.idPedido});
  @override
  _HistorialState createState() => _HistorialState(idPedido: idPedido);
}

class _HistorialState extends State<ShopperProductos> {
  final String idPedido;
  _HistorialState({this.idPedido});
   List<Producto> ordenTemp = []; // contains the final order
  final servicios = ServiciosGestionCci();
  TextEditingController comentarioController = new TextEditingController();
  TextEditingController cancelarOrdController = new TextEditingController();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  VoidCallback _showDirections;  // call a button sheet function for show Page Directions
  final prefs = PreferenciasUsuario();
  List<Producto> _productosOffline = [];
  List<int> individualCount =
      List.filled(100, 0); // list that contains the quantity of each service
  // servicios.obtenerProductos(model.pedido).then((value) =>
  //   value.map((i) => individualCount.add(int.parse(i.cantidad))
  //   ));
  int number = 1;
  int totalPrice = 0;
  int count = 0;
@override
void initState() {
    super.initState();
    _showDirections = _onButtonPressed;
  }
  
  // this function add the  principal service of user

  // this function  decrease the  number of people that give the pricipal service
  void removeOrder(tot, key) {
    setState(() {
      if (totalPrice > 0 && tot != null) {
        totalPrice -= int.parse(tot);
        count--;
      }
    });
  }
  

  // this function increase the  number of people that give the pricipal service
  void addOrder(tot) {
    setState(() {
      if (count < number) {
        totalPrice += int.parse(tot);
        count++;
      }
    });
  }

  // this function  decrease the  number of  aditionals items  that has the pricipal service
  void subtractNumbers() {
    setState(() {
      if (number > 1) {
        number--;
      }
    });
  }
  // this function  increase the  number of  aditionals items  that has the pricipal service

  void addNumbers() {
    setState(() {
      number = number + 1;
    });
  }

  void increment(int index, Producto producto) {
    setState(() {
      if (individualCount[index] == 0) {
        individualCount[index] = (double.parse(producto.cantidad)).round();
      }
      individualCount[index]++;
    });
  }

  void decrement(int index, Producto producto) {
    setState(() {
      if (individualCount[index] > 0) {
        individualCount[index]--;
      }
    });
  }

  Future<List<Producto>> cargarProductosOffline() async {
    var listJson = json.decode(prefs.listaProductos) as List;

    _productosOffline = listJson.map((i) => Producto.fromJson(i)).toList();
    return _productosOffline;
  }

  Future<List<Producto>> cargarOrdenFinal() async {
    if (ordenTemp.isEmpty) {
      var listJson = json.decode(prefs.ordenFinal) as List;

      List<Producto> orden = listJson.map((i) => Producto.fromJson(i)).toList();
      ordenTemp =orden;
      return orden;
    } else {
      return ordenTemp;
    }
  }
  
   void _onButtonPressed() {
    setState(() {
      _showDirections = null; 

    }); 
    final productos = itemsPickings();
    _scaffoldKey.currentState.showBottomSheet( (context) {
      return Container(
        color: Colors.black,
        child: Container(
          child: Checkin(idPedido: idPedido,listaProductos: productos,),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      );
    })
    .closed
    .whenComplete((){
      if(mounted){
        setState((){
        _showDirections = _onButtonPressed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provUsuario = Provider.of<ProvUsuario>(context);
    provUsuario.estadoOrden = prefs.listaEstados[prefs.estado];
    print(ordenTemp);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
         resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Text("Productos",
                style: TextStyle(
                    color: Color(0xFF036435b),
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.white12,
          elevation: 0,
          leading: new IconButton(
              icon: new Icon(
                FontAwesomeIcons.opencart,
                color: Colors.redAccent[700],
                size: size.width * 0.1,
              ),
              onPressed: () {}),
          bottom: TabBar(
            labelColor: Color(0xFF36435B),
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.hourglassHalf,
                    color: Colors.redAccent[700]),
                text: 'Faltantes',
              ),
              Tab(
                  icon: Icon(
                    FontAwesomeIcons.shopify,
                    color: Colors.greenAccent[700],
                  ),
                  text: 'Listos'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                FutureBuilder(
                  future: (prefs.listaProductos == '')
                      ? servicios.obtenerProductos(idPedido)
                      : cargarProductosOffline(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Producto>> snapshot) {
                    if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      final productos = snapshot.data;
                      return ListView.builder(
                        key: UniqueKey(),
                        itemCount: productos.length,
                        itemBuilder: (context, i) => ListTileItem(
                          producto: productos[i],
                          count: individualCount[i] == 0
                              ? (double.parse(productos[i].cantidad).round())
                              : individualCount[i],
                          decrement: () => decrement(i, productos[i]),
                          increment: () => increment(i, productos[i]),
                          addAditional: () => addAditionalOrder(
                              productos[i], individualCount[i]),
                          agregarComentario: () => agregarComentario(
                              productos[i], comentarioController.text),
                          comentarioController: comentarioController,
                        ),
                      );
                    } else {
                      
                      return Center(child:prefs.listaProductos != ''? CircularProgressIndicator():ListTile(
                              title: Text(
                                'Tienes todos tus productos en el carrito!',
                                style: TextStyle(fontSize: size.width * 0.05),
                              ),
                              leading: Icon(
                                FontAwesomeIcons.cartArrowDown,
                                color: Colors.redAccent[700],
                              )),
                        );
                      
                    }
                  },
                ),
                FutureBuilder(
                    future: cargarOrdenFinal(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Producto>> snapshot) {
                      if (snapshot.hasData) {
                        final productos = snapshot.data;
                        return ListView.builder(
                            key: UniqueKey(),
                            itemCount: productos.length,
                            itemBuilder: (context, i) => ListTileItem(
                                  producto: productos[i],
                                  count: individualCount[i] == 0
                                      ? (double.parse(productos[i].cantidad)
                                          .round())
                                      : individualCount[i],
                                  decrement: () => decrement(i, productos[i]),
                                  increment: () => increment(i, productos[i]),
                                  addAditional: () => addAditionalOrder(
                                      productos[i], individualCount[i]),
                                  agregarComentario: () => agregarComentario(
                                      productos[i], comentarioController.text),
                                  comentarioController: comentarioController,
                                ));
                      } else {
                        return Center(
                          child: ListTile(
                              title: Text(
                                'Aún no tienes productos en el carrito!',
                                style: TextStyle(fontSize: size.width * 0.05),
                              ),
                              leading: Icon(
                                FontAwesomeIcons.sadCry,
                                color: Colors.redAccent[700],
                              )),
                        );
                      }
                    })
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      bottomCustom(null, () => _showDirections()),
                    ]))
          ],
        ),
      ),
    );
  }

  addAditionalOrder(Producto producto, int count) {
    setState(() {
      for (var productoFinal in ordenTemp) {
        if (productoFinal.oidArticulo == producto.oidArticulo) {
          ordenTemp.remove(productoFinal);
          prefs.ordenFinal = json.encode(ordenTemp);
          break;
        }
      }

      producto.cantidad = count.toString();
      ordenTemp.add(producto);
      _productosOffline.remove(producto);
       prefs.listaProductos = json.encode(_productosOffline);
      if(_productosOffline.isEmpty){
        prefs.listaProductos='';
      }
     
      prefs.ordenFinal = json.encode(ordenTemp);
    });
    print(ordenTemp);
  }

  agregarComentario(Producto producto, String comentario) {
    for (var productoFinal in ordenTemp) {
      if (producto.oidArticulo == productoFinal.oidArticulo) {
        setState(() {
          productoFinal.nota = comentario;
        
        });
      }
    }
    setState(() {
      producto.nota=comentario;
        
    });
    print(producto);
  }

  List<PickingProducto> itemsPickings() {
    List<PickingProducto> itemsPicking = [];

    for (var prod in ordenTemp) {
      PickingProducto item = PickingProducto(
          cant: prod.cantidad,
          oidRegistro: prod.oidRegistro,
          oidPedido: idPedido,
          nota: prod.nota,
          estado: prefs.estado.toString(),
          estadoActualizado: 0,
          txtEstado: prefs.listaEstados[prefs.estado]);
      itemsPicking.add(item);
    }
    return itemsPicking;
  }

  Widget bottomCustom(String texto, Function funcion) {
    final size = MediaQuery.of(context).size;
    final provUsuario = Provider.of<ProvUsuario>(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: size.height * 0.04,
        left: size.width * 0.05,
        right: size.width * 0.05,
      ),
      child: RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                color: texto != null
                    ? Colors.redAccent[700]
                    : Colors.greenAccent[700],
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.fromLTRB(size.width * 0.1, size.height * 0.02,
                  size.width * 0.1, size.height * 0.02),
              child: Text(texto == null ? provUsuario.estadoOrden : texto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.04)),
            ),
          ),
          onPressed: () {
            funcion();
          }),
    );
  }


}

class ListTileItem extends StatelessWidget {
  final Producto producto;
  final int count;
  final Function decrement;
  final Function increment;
  final Function addAditional;
  final Function agregarComentario;
  final TextEditingController comentarioController;

  ListTileItem({
    this.producto,
    this.count,
    this.decrement,
    this.increment,
    this.addAditional,
    this.agregarComentario,
    this.comentarioController,
  });

  @override
  Widget build(BuildContext contextList) {
    final size = MediaQuery.of(contextList).size;
    return Card(
        elevation: 4,
        margin: EdgeInsets.only(
            left: size.width * 0.06,
            right: size.width * 0.06,
            top: 15,
            bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Dismissible(
          key: UniqueKey(),
          background: slideRightBackground(),
          onDismissed: (direction) {
            addAditional();
          },
          child: Stack(key: key, children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
              child: Row(children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${producto.oidArticulo.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18.0)),
                      Text('${producto.descripcion.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15.0)),
                    ]),
              ]),
            ),
            Padding(
                padding: EdgeInsets.only(),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      count == 0
                          ? Container()
                          : IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: size.width * 0.1,
                              ),
                              color: Colors.red,
                              onPressed: () {
                                decrement();
                              }),
                      Container(
                        padding: const EdgeInsets.only(
                            bottom: 2, right: 12, left: 12),
                        child: Text(
                          '$count' + '(${producto.undmedida})',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: size.width * 0.04),
                        ),
                      ),
                      IconButton(
                          key: key,
                          icon: Icon(
                            Icons.add,
                            size: size.width * 0.1,
                          ),
                          color: Colors.greenAccent[400],
                          onPressed: () {
                            increment();
                          }),
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.ellipsisV,
                            color: Color(0xFF036435b),
                          ),
                          onPressed: () {
                            showDialog(
                                context: contextList,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context));
                          }),
                    ])),
          ]),
        ));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Agregar comentario'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: comentarioController,
            decoration: InputDecoration(labelText: 'Comentario'),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            agregarComentario();
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.greenAccent[400],
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              "Agregar producto",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
