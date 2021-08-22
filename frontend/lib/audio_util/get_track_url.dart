import 'get_track_url_stub.dart'
// ignore: uri_does_not_exist
if (dart.library.html) 'get_track_url_web.dart';


String getRecordURL(
    String path
    ){
  return getRecordURLImpl(path);
}
