enum ErrorMessages {
  getLocaleDataError('ERR_FETCH_LOCALE_DATA'),
  unsupportedStorageItem('Item type is not supported'),
  unexpectedErrorWhenAddToLocal('An error occurred when add to local'),
  unexpectedErrorWhenDeleteFromLocal('An error occurred when delete from local'),
  unsupportedGetMethodUsedForStorage('This method not supports lists. Use getListValue method instead of this.'),
  unsupportedSetMethodUsedForStorage('This method not supports lists. Use getAllValue method instead of this.'),
  valueNotFoundOnStorageKey('Value not found on this key'),
  invalidStorageItem('Item type invalid! It must be primitive or LocalStorageModel type');

  final String code;
  const ErrorMessages(this.code);
}
