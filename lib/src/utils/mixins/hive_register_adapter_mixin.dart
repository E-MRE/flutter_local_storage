/// If you want to save any model to locale, you have to register by this mixin.
/// its example
///  if (!Hive.isAdapterRegistered(HiveKeys.user.value)) {
///       Hive.registerAdapter<AuthData>(AuthDataAdapter());
///     }
///
mixin HiveRegisterAdapterMixin {
  void registerAdapters() {}
}
