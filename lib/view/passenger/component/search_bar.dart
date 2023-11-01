
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget with PreferredSizeWidget{
  SearchBar({Key? key, required this.textEditingController, this.hintText, this.onSearch}) : super(key: key);

  TextEditingController textEditingController;
  String? hintText;
  final onSearch;

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBarState extends State<SearchBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Iterable<String> _suggest(TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    } else {
      return {
        'Kenny',
        'Kit Kit',
        'All'
      };
    }
  }

  void _selected(String selection) {
    // widget.textEditingController.text = selection;
    widget.onSearch(selection);
  }

  Widget _searchField(BuildContext context, TextEditingController controller, FocusNode node, VoidCallback onFieldSubmitted) {
    widget.textEditingController = controller;
    FocusNode blankNode = FocusNode();
    return TextFormField(
      controller: widget.textEditingController,
      focusNode: node,
      maxLines: 1,
      onFieldSubmitted: (String value) {
        widget.onSearch(value);
      },
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Select child ... ',
        hintStyle: TextStyle(color: Colors.grey, fontSize: fitSize(35)),
        // contentPadding: const EdgeInsets.only(top: 5),
        prefixIcon: IconButton(
          icon: Icon(
            Icons.search,
            size: fitSize(45),
            color: Colors.black38,
          ),
          onPressed: () {widget.onSearch(widget.textEditingController.value.text);},
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.close,
            size: fitSize(45),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(blankNode);
            widget.textEditingController.clear();
          },
        ),
      ),
    );
  }

  Widget _optionsField(BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
    FocusNode blankNode = FocusNode();
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: Container(
          height: fitSize(500),
          child: ListView.builder(
            padding: EdgeInsets.all(fitSize(20)),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = options.elementAt(index);
              return GestureDetector(
                onTap: () {
                  onSelected(option);
                  FocusScope.of(context).requestFocus(blankNode);
                },
                child: ListTile(
                  title: Text(option),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.blueAccent,
      title: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: fitSize(2.5)),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(fitSize(12.5))),
        ),
        alignment: Alignment.center,
        height: fitSize(125),
        child: Autocomplete<String>(
          optionsBuilder: _suggest,
          onSelected: _selected,
          fieldViewBuilder: _searchField,
          optionsViewBuilder: _optionsField,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: fitSize(20)),
          child: InkWell(
              onTap: () {
              },
              child: Image.asset(
                'assets/image/icon/more.png',
                width: fitSize(75),
                height: fitSize(75),
                color: Colors.white,
              )
          ),
        ),
      ],
    );
  }


}
