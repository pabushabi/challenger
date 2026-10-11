// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_event_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddEventState {

 CubitState get status; List<EventFieldDef> get fieldDefs; Map<String, String> get values; String? get errorMessage;
/// Create a copy of AddEventState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddEventStateCopyWith<AddEventState> get copyWith => _$AddEventStateCopyWithImpl<AddEventState>(this as AddEventState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddEventState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.fieldDefs, fieldDefs)&&const DeepCollectionEquality().equals(other.values, values)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(fieldDefs),const DeepCollectionEquality().hash(values),errorMessage);

@override
String toString() {
  return 'AddEventState(status: $status, fieldDefs: $fieldDefs, values: $values, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AddEventStateCopyWith<$Res>  {
  factory $AddEventStateCopyWith(AddEventState value, $Res Function(AddEventState) _then) = _$AddEventStateCopyWithImpl;
@useResult
$Res call({
 CubitState status, List<EventFieldDef> fieldDefs, Map<String, String> values, String? errorMessage
});




}
/// @nodoc
class _$AddEventStateCopyWithImpl<$Res>
    implements $AddEventStateCopyWith<$Res> {
  _$AddEventStateCopyWithImpl(this._self, this._then);

  final AddEventState _self;
  final $Res Function(AddEventState) _then;

/// Create a copy of AddEventState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? fieldDefs = null,Object? values = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitState,fieldDefs: null == fieldDefs ? _self.fieldDefs : fieldDefs // ignore: cast_nullable_to_non_nullable
as List<EventFieldDef>,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddEventState].
extension AddEventStatePatterns on AddEventState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddEventState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddEventState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddEventState value)  $default,){
final _that = this;
switch (_that) {
case _AddEventState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddEventState value)?  $default,){
final _that = this;
switch (_that) {
case _AddEventState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CubitState status,  List<EventFieldDef> fieldDefs,  Map<String, String> values,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddEventState() when $default != null:
return $default(_that.status,_that.fieldDefs,_that.values,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CubitState status,  List<EventFieldDef> fieldDefs,  Map<String, String> values,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AddEventState():
return $default(_that.status,_that.fieldDefs,_that.values,_that.errorMessage);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CubitState status,  List<EventFieldDef> fieldDefs,  Map<String, String> values,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AddEventState() when $default != null:
return $default(_that.status,_that.fieldDefs,_that.values,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AddEventState extends AddEventState {
  const _AddEventState({this.status = CubitState.initial, required this.fieldDefs, required this.values, this.errorMessage}): super._();
  

@override@JsonKey() final  CubitState status;
@override final  List<EventFieldDef> fieldDefs;
@override final  Map<String, String> values;
@override final  String? errorMessage;

/// Create a copy of AddEventState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddEventStateCopyWith<_AddEventState> get copyWith => __$AddEventStateCopyWithImpl<_AddEventState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddEventState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.fieldDefs, fieldDefs)&&const DeepCollectionEquality().equals(other.values, values)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(fieldDefs),const DeepCollectionEquality().hash(values),errorMessage);

@override
String toString() {
  return 'AddEventState(status: $status, fieldDefs: $fieldDefs, values: $values, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AddEventStateCopyWith<$Res> implements $AddEventStateCopyWith<$Res> {
  factory _$AddEventStateCopyWith(_AddEventState value, $Res Function(_AddEventState) _then) = __$AddEventStateCopyWithImpl;
@override @useResult
$Res call({
 CubitState status, List<EventFieldDef> fieldDefs, Map<String, String> values, String? errorMessage
});




}
/// @nodoc
class __$AddEventStateCopyWithImpl<$Res>
    implements _$AddEventStateCopyWith<$Res> {
  __$AddEventStateCopyWithImpl(this._self, this._then);

  final _AddEventState _self;
  final $Res Function(_AddEventState) _then;

/// Create a copy of AddEventState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? fieldDefs = null,Object? values = null,Object? errorMessage = freezed,}) {
  return _then(_AddEventState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CubitState,fieldDefs: null == fieldDefs ? _self.fieldDefs : fieldDefs // ignore: cast_nullable_to_non_nullable
as List<EventFieldDef>,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
