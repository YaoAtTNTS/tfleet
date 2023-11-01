

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/files.dart';
import 'package:tfleet/service/passenger/files_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/passenger/my/file_full_page_view.dart';

class FilesCard extends StatefulWidget {
  const FilesCard({Key? key, required this.files, required this.onDelete}) : super(key: key);

  final Files files;
  final Function onDelete;

  @override
  State<FilesCard> createState() => _FilesCardState();
}

class _FilesCardState extends State<FilesCard> {

  Widget _title() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.files.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: fitSize(40),
            color: TColor.active,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _remark() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        'Term ${widget.files.termNo ?? ''} ${widget.files.year ?? ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fitSize(30),
          color: TColor.active,
        ),
      ),
    );
  }

  Widget _date() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.files.createdAt != null ? dateToAlphaMonth(widget.files.createdAt) : '' ,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fitSize(30),
          color: TColor.inactive,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FileFullPageView(files: widget.files),
        ));
      },
      child: Container(
        height: fitSize(200),
        color: const Color(0xfffff8fa),
        margin: const EdgeInsets.only(left: 27, right: 27),
        padding: EdgeInsets.only(left: fitSize(17.5), top: fitSize(40)),
        child: Column(
          children: [
            _title(),
            SizedBox(height: fitSize(12.5)),
            _remark(),
            _date()
          ],
        ),
      ),
    );
  }

  /*Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.confirmToRemoveFiles ?? 'Confirm to remove this file?',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                widget.onDelete(widget.files);
                FilesService.deleteFiles(widget.files.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/
}
