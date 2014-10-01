#include <ruby.h>
#include <ruby/thread.h>
#include "wit.h"

struct wit_context *context;

static VALUE e_WitError;

static VALUE libwit_init(int argc, VALUE *argv, VALUE obj) {
	const char *device_opt = NULL;
	VALUE device = Qnil;
	rb_scan_args(argc, argv, "01", &device);
	if (device != Qnil) {
		Check_Type(device, T_STRING);
		device_opt = StringValuePtr(device);
	}
	context = wit_init(device_opt);
	return Qnil;
}

static VALUE libwit_close(VALUE obj) {
	if (context != NULL) {
		wit_close(context);
	}
	return Qnil;
}

static VALUE libwit_text_query(VALUE obj, VALUE text, VALUE access_token) {
	const char *resp;
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	Check_Type(text, T_STRING);
	Check_Type(access_token, T_STRING);
	resp = wit_text_query(context, StringValuePtr(text), StringValuePtr(access_token));
	VALUE str = rb_str_new2(resp);
	xfree((char *)resp);
	return str;
}

static VALUE libwit_voice_query_start(VALUE obj, VALUE access_token) {
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	Check_Type(access_token, T_STRING);
	wit_voice_query_start(context, StringValuePtr(access_token));
	return Qnil;
}

static VALUE libwit_voice_query_stop(VALUE obj) {
	const char *resp;
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	resp = wit_voice_query_stop(context);
	VALUE str = rb_str_new2(resp);
	free((char *)resp);
	return str;
}

static VALUE libwit_voice_query_auto(VALUE obj, VALUE access_token)
{
	const char *resp;
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	Check_Type(access_token, T_STRING);
	resp = wit_voice_query_auto(context, StringValuePtr(access_token));
	VALUE str = rb_str_new2(resp);
	free((char *)resp);
	return str;
}

VALUE rb_cb;

static VALUE thread_wrapper_proc(void *args) {
	VALUE str = rb_str_new2((char *) args);
	free(args);
	rb_funcall(rb_cb, rb_intern("call"), 1, str);
	return Qnil;
}

static VALUE thread_wrapper_meth(void *args) {
	VALUE str = rb_str_new2((char *) args);
	free(args);
	rb_funcall(rb_class_of(rb_cb), rb_to_id(rb_cb), 1, str);
	return Qnil;
}

void my_wit_resp_callback(char *res) {
	if (rb_cb == Qnil)
		rb_raise(rb_eRuntimeError, "callback is nil");
	if (rb_class_of(rb_cb) == rb_cProc)
		rb_thread_create(thread_wrapper_proc, (char *)res);
	else if (rb_class_of(rb_cb) == rb_cSymbol)
		rb_thread_create(thread_wrapper_meth, (char *)res);
	else
		rb_raise(rb_eTypeError, "expected Proc or Symbol callback");
}

static VALUE libwit_text_query_async(VALUE obj, VALUE text, VALUE access_token, VALUE callback)
{
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	Check_Type(text, T_STRING);
	Check_Type(access_token, T_STRING);
	if (rb_class_of(callback) != rb_cSymbol && rb_class_of(callback) != rb_cProc)
		rb_raise(rb_eTypeError, "expected Proc or Symbol callback");
	rb_cb = callback;
	wit_text_query_async(context, StringValuePtr(text), StringValuePtr(access_token), my_wit_resp_callback);
	return Qnil;
}

static VALUE libwit_voice_query_stop_async(VALUE obj, VALUE callback)
{
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	if (rb_class_of(callback) != rb_cSymbol && rb_class_of(callback) != rb_cProc)
		rb_raise(rb_eTypeError, "expected Proc or Symbol callback");
	rb_cb = callback;
	wit_voice_query_stop_async(context, my_wit_resp_callback);
	return Qnil;
}

static VALUE libwit_voice_query_auto_async(VALUE obj, VALUE access_token, VALUE callback)
{
	if (context == NULL)
		rb_raise(e_WitError, "Wit context uninitialized (did you call Wit.init?)");
	Check_Type(access_token, T_STRING);
	if (rb_class_of(callback) != rb_cSymbol && rb_class_of(callback) != rb_cProc)
		rb_raise(rb_eTypeError, "expected Proc or Symbol callback");
	rb_cb = callback;
	wit_voice_query_auto_async(context, StringValuePtr(access_token), my_wit_resp_callback);
	return Qnil;
}

void Init_wit(void) {
	VALUE wit_module = rb_define_module("Wit");
	e_WitError = rb_define_class_under(wit_module, "Wit error", rb_eStandardError);
	rb_define_module_function(wit_module, "init", libwit_init, -1);
	rb_define_module_function(wit_module, "close", libwit_close, 0);
	rb_define_module_function(wit_module, "text_query", libwit_text_query, 2);
	rb_define_module_function(wit_module, "voice_query_start", libwit_voice_query_start, 1);
	rb_define_module_function(wit_module, "voice_query_stop", libwit_voice_query_stop, 0);
	rb_define_module_function(wit_module, "voice_query_auto", libwit_voice_query_auto, 1);
	rb_define_module_function(wit_module, "text_query_async", libwit_text_query_async, 3);
	rb_define_module_function(wit_module, "voice_query_stop_async", libwit_voice_query_stop_async, 1);
	rb_define_module_function(wit_module, "voice_query_auto_async", libwit_voice_query_auto_async, 2);
}
