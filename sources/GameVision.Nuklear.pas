{==============================================================================
   ___              __   ___    _
  / __|__ _ _ __  __\ \ / (_)__(_)___ _ _
 | (_ / _` | '  \/ -_) V /| (_-< / _ \ ' \
  \___\__,_|_|_|_\___|\_/ |_/__/_\___/_||_|
                  Toolkit™

 Copyright © 2022 tinyBigGAMES™ LLC
 All Rights Reserved.

 Website: https://tinybiggames.com
 Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
============================================================================= }

unit GameVision.Nuklear;

interface

{$I GameVision.Defines.inc}

//{$MINENUMSIZE 4}
//{$WARN SYMBOL_PLATFORM OFF}

const
  NUKLEAR_DLL = 'Nuklear.dll';
  _PU = '';

const
  NK_INCLUDE_DEFAULT_ALLOCATOR = 1;
  NK_INCLUDE_STANDARD_VARARGS = 1;
  NK_UNDEFINED = (-1.0);
  NK_UTF_INVALID = $FFFD;
  NK_UTF_SIZE = 4;
  NK_INPUT_MAX = 16;
  NK_MAX_NUMBER_BUFFER = 64;
  NK_SCROLLBAR_HIDING_TIMEOUT = 4.0;
  NK_TEXTEDIT_UNDOSTATECOUNT = 99;
  NK_TEXTEDIT_UNDOCHARCOUNT = 999;
  NK_MAX_LAYOUT_ROW_TEMPLATE_COLUMNS = 16;
  NK_CHART_MAX_SLOT = 4;
  NK_WINDOW_MAX_NAME = 64;
  NK_BUTTON_BEHAVIOR_STACK_SIZE = 8;
  NK_FONT_STACK_SIZE = 8;
  NK_STYLE_ITEM_STACK_SIZE = 16;
  NK_FLOAT_STACK_SIZE = 32;
  NK_VECTOR_STACK_SIZE = 16;
  NK_FLAGS_STACK_SIZE = 32;
  NK_COLOR_STACK_SIZE = 32;
  NK_PI = 3.141592654;
  NK_MAX_FLOAT_PRECISION = 2;

const
  nk_false = 0;
  nk_true = 1;

type
  nk_heading = Integer;
  Pnk_heading = ^nk_heading;

const
  NK_UP = 0;
  NK_RIGHT = 1;
  NK_DOWN = 2;
  NK_LEFT = 3;

type
  nk_button_behavior = Integer;
  Pnk_button_behavior = ^nk_button_behavior;

const
  NK_BUTTON_DEFAULT = 0;
  NK_BUTTON_REPEATER = 1;

type
  nk_modify = Integer;
  Pnk_modify = ^nk_modify;

const
  NK_FIXED = 0;
  NK_MODIFIABLE = 1;

type
  nk_orientation = Integer;
  Pnk_orientation = ^nk_orientation;

const
  NK_VERTICAL = 0;
  NK_HORIZONTAL = 1;

type
  nk_collapse_states = Integer;
  Pnk_collapse_states = ^nk_collapse_states;

const
  NK_MINIMIZED = 0;
  NK_MAXIMIZED = 1;

type
  nk_show_states = Integer;
  Pnk_show_states = ^nk_show_states;

const
  NK_HIDDEN = 0;
  NK_SHOWN = 1;

type
  nk_chart_type = Integer;
  Pnk_chart_type = ^nk_chart_type;

const
  NK_CHART_LINES = 0;
  NK_CHART_COLUMN = 1;
  NK_CHART_MAX = 2;

type
  nk_chart_event = Integer;
  Pnk_chart_event = ^nk_chart_event;

const
  NK_CHART_HOVERING = 1;
  NK_CHART_CLICKED = 2;

type
  nk_color_format = Integer;
  Pnk_color_format = ^nk_color_format;

const
  NK_RGB = 0;
  NK_RGBA = 1;

type
  nk_popup_type = Integer;
  Pnk_popup_type = ^nk_popup_type;

const
  NK_POPUP_STATIC = 0;
  NK_POPUP_DYNAMIC = 1;

type
  nk_layout_format = Integer;
  Pnk_layout_format = ^nk_layout_format;

const
  NK_DYNAMIC = 0;
  NK_STATIC = 1;

type
  nk_tree_type = Integer;
  Pnk_tree_type = ^nk_tree_type;

const
  NK_TREE_NODE = 0;
  NK_TREE_TAB = 1;

type
  nk_symbol_type = Integer;
  Pnk_symbol_type = ^nk_symbol_type;

const
  NK_SYMBOL_NONE = 0;
  NK_SYMBOL_X = 1;
  NK_SYMBOL_UNDERSCORE = 2;
  NK_SYMBOL_CIRCLE_SOLID = 3;
  NK_SYMBOL_CIRCLE_OUTLINE = 4;
  NK_SYMBOL_RECT_SOLID = 5;
  NK_SYMBOL_RECT_OUTLINE = 6;
  NK_SYMBOL_TRIANGLE_UP = 7;
  NK_SYMBOL_TRIANGLE_DOWN = 8;
  NK_SYMBOL_TRIANGLE_LEFT = 9;
  NK_SYMBOL_TRIANGLE_RIGHT = 10;
  NK_SYMBOL_PLUS = 11;
  NK_SYMBOL_MINUS = 12;
  NK_SYMBOL_MAX = 13;

type
  nk_keys = Integer;
  Pnk_keys = ^nk_keys;

const
  NK_KEY_NONE = 0;
  NK_KEY_SHIFT = 1;
  NK_KEY_CTRL = 2;
  NK_KEY_DEL = 3;
  NK_KEY_ENTER = 4;
  NK_KEY_TAB = 5;
  NK_KEY_BACKSPACE = 6;
  NK_KEY_COPY = 7;
  NK_KEY_CUT = 8;
  NK_KEY_PASTE = 9;
  NK_KEY_UP = 10;
  NK_KEY_DOWN = 11;
  NK_KEY_LEFT = 12;
  NK_KEY_RIGHT = 13;
  NK_KEY_TEXT_INSERT_MODE = 14;
  NK_KEY_TEXT_REPLACE_MODE = 15;
  NK_KEY_TEXT_RESET_MODE = 16;
  NK_KEY_TEXT_LINE_START = 17;
  NK_KEY_TEXT_LINE_END = 18;
  NK_KEY_TEXT_START = 19;
  NK_KEY_TEXT_END = 20;
  NK_KEY_TEXT_UNDO = 21;
  NK_KEY_TEXT_REDO = 22;
  NK_KEY_TEXT_SELECT_ALL = 23;
  NK_KEY_TEXT_WORD_LEFT = 24;
  NK_KEY_TEXT_WORD_RIGHT = 25;
  NK_KEY_SCROLL_START = 26;
  NK_KEY_SCROLL_END = 27;
  NK_KEY_SCROLL_DOWN = 28;
  NK_KEY_SCROLL_UP = 29;
  NK_KEY_MAX = 30;

type
  nk_buttons = Integer;
  Pnk_buttons = ^nk_buttons;

const
  NK_BUTTON_LEFT = 0;
  NK_BUTTON_MIDDLE = 1;
  NK_BUTTON_RIGHT = 2;
  NK_BUTTON_DOUBLE = 3;
  NK_BUTTON_MAX = 4;

type
  nk_anti_aliasing = Integer;
  Pnk_anti_aliasing = ^nk_anti_aliasing;

const
  NK_ANTI_ALIASING_OFF = 0;
  NK_ANTI_ALIASING_ON = 1;

type
  nk_convert_result = Integer;
  Pnk_convert_result = ^nk_convert_result;

const
  NK_CONVERT_SUCCESS = 0;
  NK_CONVERT_INVALID_PARAM = 1;
  NK_CONVERT_COMMAND_BUFFER_FULL = 2;
  NK_CONVERT_VERTEX_BUFFER_FULL = 4;
  NK_CONVERT_ELEMENT_BUFFER_FULL = 8;

type
  nk_panel_flags = Integer;
  Pnk_panel_flags = ^nk_panel_flags;

const
  NK_WINDOW_BORDER = 1;
  NK_WINDOW_MOVABLE = 2;
  NK_WINDOW_SCALABLE = 4;
  NK_WINDOW_CLOSABLE = 8;
  NK_WINDOW_MINIMIZABLE = 16;
  NK_WINDOW_NO_SCROLLBAR = 32;
  NK_WINDOW_TITLE = 64;
  NK_WINDOW_SCROLL_AUTO_HIDE = 128;
  NK_WINDOW_BACKGROUND = 256;
  NK_WINDOW_SCALE_LEFT = 512;
  NK_WINDOW_NO_INPUT = 1024;

type
  nk_widget_layout_states = Integer;
  Pnk_widget_layout_states = ^nk_widget_layout_states;

const
  NK_WIDGET_INVALID = 0;
  NK_WIDGET_VALID = 1;
  NK_WIDGET_ROM = 2;

type
  nk_widget_states = Integer;
  Pnk_widget_states = ^nk_widget_states;

const
  NK_WIDGET_STATE_MODIFIED = 2;
  NK_WIDGET_STATE_INACTIVE = 4;
  NK_WIDGET_STATE_ENTERED = 8;
  NK_WIDGET_STATE_HOVER = 16;
  NK_WIDGET_STATE_ACTIVED = 32;
  NK_WIDGET_STATE_LEFT = 64;
  NK_WIDGET_STATE_HOVERED = 18;
  NK_WIDGET_STATE_ACTIVE = 34;

type
  nk_text_align = Integer;
  Pnk_text_align = ^nk_text_align;

const
  NK_TEXT_ALIGN_LEFT = 1;
  NK_TEXT_ALIGN_CENTERED = 2;
  NK_TEXT_ALIGN_RIGHT = 4;
  NK_TEXT_ALIGN_TOP = 8;
  NK_TEXT_ALIGN_MIDDLE = 16;
  NK_TEXT_ALIGN_BOTTOM = 32;

type
  nk_text_alignment = Integer;
  Pnk_text_alignment = ^nk_text_alignment;

const
  NK_TEXT_LEFT = 17;
  NK_TEXT_CENTERED = 18;
  NK_TEXT_RIGHT = 20;

type
  nk_edit_flags = Integer;
  Pnk_edit_flags = ^nk_edit_flags;

const
  NK_EDIT_DEFAULT = 0;
  NK_EDIT_READ_ONLY = 1;
  NK_EDIT_AUTO_SELECT = 2;
  NK_EDIT_SIG_ENTER = 4;
  NK_EDIT_ALLOW_TAB = 8;
  NK_EDIT_NO_CURSOR = 16;
  NK_EDIT_SELECTABLE = 32;
  NK_EDIT_CLIPBOARD = 64;
  NK_EDIT_CTRL_ENTER_NEWLINE = 128;
  NK_EDIT_NO_HORIZONTAL_SCROLL = 256;
  NK_EDIT_ALWAYS_INSERT_MODE = 512;
  NK_EDIT_MULTILINE = 1024;
  NK_EDIT_GOTO_END_ON_ACTIVATE = 2048;

type
  nk_edit_types = Integer;
  Pnk_edit_types = ^nk_edit_types;

const
  NK_EDIT_SIMPLE = 512;
  NK_EDIT_FIELD = 608;
  NK_EDIT_BOX = 1640;
  NK_EDIT_EDITOR = 1128;

type
  nk_edit_events = Integer;
  Pnk_edit_events = ^nk_edit_events;

const
  NK_EDIT_ACTIVE = 1;
  NK_EDIT_INACTIVE = 2;
  NK_EDIT_ACTIVATED = 4;
  NK_EDIT_DEACTIVATED = 8;
  NK_EDIT_COMMITED = 16;

type
  nk_style_colors = Integer;
  Pnk_style_colors = ^nk_style_colors;

const
  NK_COLOR_TEXT = 0;
  NK_COLOR_WINDOW = 1;
  NK_COLOR_HEADER = 2;
  NK_COLOR_BORDER = 3;
  NK_COLOR_BUTTON = 4;
  NK_COLOR_BUTTON_HOVER = 5;
  NK_COLOR_BUTTON_ACTIVE = 6;
  NK_COLOR_TOGGLE = 7;
  NK_COLOR_TOGGLE_HOVER = 8;
  NK_COLOR_TOGGLE_CURSOR = 9;
  NK_COLOR_SELECT = 10;
  NK_COLOR_SELECT_ACTIVE = 11;
  NK_COLOR_SLIDER = 12;
  NK_COLOR_SLIDER_CURSOR = 13;
  NK_COLOR_SLIDER_CURSOR_HOVER = 14;
  NK_COLOR_SLIDER_CURSOR_ACTIVE = 15;
  NK_COLOR_PROPERTY = 16;
  NK_COLOR_EDIT = 17;
  NK_COLOR_EDIT_CURSOR = 18;
  NK_COLOR_COMBO = 19;
  NK_COLOR_CHART = 20;
  NK_COLOR_CHART_COLOR = 21;
  NK_COLOR_CHART_COLOR_HIGHLIGHT = 22;
  NK_COLOR_SCROLLBAR = 23;
  NK_COLOR_SCROLLBAR_CURSOR = 24;
  NK_COLOR_SCROLLBAR_CURSOR_HOVER = 25;
  NK_COLOR_SCROLLBAR_CURSOR_ACTIVE = 26;
  NK_COLOR_TAB_HEADER = 27;
  NK_COLOR_COUNT = 28;

type
  nk_style_cursor = Integer;
  Pnk_style_cursor = ^nk_style_cursor;

const
  NK_CURSOR_ARROW = 0;
  NK_CURSOR_TEXT = 1;
  NK_CURSOR_MOVE = 2;
  NK_CURSOR_RESIZE_VERTICAL = 3;
  NK_CURSOR_RESIZE_HORIZONTAL = 4;
  NK_CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT = 5;
  NK_CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT = 6;
  NK_CURSOR_COUNT = 7;

type
  nk_allocation_type = Integer;
  Pnk_allocation_type = ^nk_allocation_type;

const
  NK_BUFFER_FIXED = 0;
  NK_BUFFER_DYNAMIC = 1;

type
  nk_buffer_allocation_type = Integer;
  Pnk_buffer_allocation_type = ^nk_buffer_allocation_type;

const
  NK_BUFFER_FRONT = 0;
  NK_BUFFER_BACK = 1;
  NK_BUFFER_MAX = 2;

type
  nk_text_edit_type = Integer;
  Pnk_text_edit_type = ^nk_text_edit_type;

const
  NK_TEXT_EDIT_SINGLE_LINE = 0;
  NK_TEXT_EDIT_MULTI_LINE = 1;

type
  nk_text_edit_mode = Integer;
  Pnk_text_edit_mode = ^nk_text_edit_mode;

const
  NK_TEXT_EDIT_MODE_VIEW = 0;
  NK_TEXT_EDIT_MODE_INSERT = 1;
  NK_TEXT_EDIT_MODE_REPLACE = 2;

type
  nk_command_type = Integer;
  Pnk_command_type = ^nk_command_type;

const
  NK_COMMAND_NOP_ = 0;
  NK_COMMAND_SCISSOR_ = 1;
  NK_COMMAND_LINE_ = 2;
  NK_COMMAND_CURVE_ = 3;
  NK_COMMAND_RECT_ = 4;
  NK_COMMAND_RECT_FILLED_ = 5;
  NK_COMMAND_RECT_MULTI_COLOR_ = 6;
  NK_COMMAND_CIRCLE_ = 7;
  NK_COMMAND_CIRCLE_FILLED_ = 8;
  NK_COMMAND_ARC_ = 9;
  NK_COMMAND_ARC_FILLED_ = 10;
  NK_COMMAND_TRIANGLE_ = 11;
  NK_COMMAND_TRIANGLE_FILLED_ = 12;
  NK_COMMAND_POLYGON_ = 13;
  NK_COMMAND_POLYGON_FILLED_ = 14;
  NK_COMMAND_POLYLINE_ = 15;
  NK_COMMAND_TEXT_ = 16;
  NK_COMMAND_IMAGE_ = 17;
  NK_COMMAND_CUSTOM_ = 18;

type
  nk_command_clipping = Integer;
  Pnk_command_clipping = ^nk_command_clipping;

const
  NK_CLIPPING_OFF = 0;
  NK_CLIPPING_ON = 1;

type
  nk_style_item_type = Integer;
  Pnk_style_item_type = ^nk_style_item_type;

const
  NK_STYLE_ITEM_COLOR = 0;
  NK_STYLE_ITEM_IMAGE = 1;
  NK_STYLE_ITEM_NINE_SLICE = 2;

type
  nk_style_header_align = Integer;
  Pnk_style_header_align = ^nk_style_header_align;

const
  NK_HEADER_LEFT = 0;
  NK_HEADER_RIGHT = 1;

type
  nk_panel_type = Integer;
  Pnk_panel_type = ^nk_panel_type;

const
  NK_PANEL_NONE = 0;
  NK_PANEL_WINDOW = 1;
  NK_PANEL_GROUP = 2;
  NK_PANEL_POPUP = 4;
  NK_PANEL_CONTEXTUAL = 16;
  NK_PANEL_COMBO = 32;
  NK_PANEL_MENU = 64;
  NK_PANEL_TOOLTIP = 128;

type
  nk_panel_set = Integer;
  Pnk_panel_set = ^nk_panel_set;

const
  NK_PANEL_SET_NONBLOCK = 240;
  NK_PANEL_SET_POPUP = 244;
  NK_PANEL_SET_SUB = 246;

type
  nk_panel_row_layout_type = Integer;
  Pnk_panel_row_layout_type = ^nk_panel_row_layout_type;

const
  NK_LAYOUT_DYNAMIC_FIXED = 0;
  NK_LAYOUT_DYNAMIC_ROW = 1;
  NK_LAYOUT_DYNAMIC_FREE = 2;
  NK_LAYOUT_DYNAMIC = 3;
  NK_LAYOUT_STATIC_FIXED = 4;
  NK_LAYOUT_STATIC_ROW = 5;
  NK_LAYOUT_STATIC_FREE = 6;
  NK_LAYOUT_STATIC = 7;
  NK_LAYOUT_TEMPLATE = 8;
  NK_LAYOUT_COUNT = 9;

type
  nk_window_flags = Integer;
  Pnk_window_flags = ^nk_window_flags;

const
  NK_WINDOW_PRIVATE = 2048;
  NK_WINDOW_DYNAMIC = 2048;
  NK_WINDOW_ROM = 4096;
  NK_WINDOW_NOT_INTERACTIVE = 5120;
  NK_WINDOW_HIDDEN = 8192;
  NK_WINDOW_CLOSED = 16384;
  NK_WINDOW_MINIMIZED = 32768;
  NK_WINDOW_REMOVE_ROM = 65536;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  Pnk_draw_command = Pointer;
  PPnk_draw_command = ^Pnk_draw_command;
  Pnk_draw_list = Pointer;
  PPnk_draw_list = ^Pnk_draw_list;
  Pnk_draw_vertex_layout_element = Pointer;
  PPnk_draw_vertex_layout_element = ^Pnk_draw_vertex_layout_element;
  Pnk_style_slide = Pointer;
  PPnk_style_slide = ^Pnk_style_slide;
  Pnk_user_font_glyph = Pointer;
  PPnk_user_font_glyph = ^Pnk_user_font_glyph;
  Pnk_color = ^nk_color;
  Pnk_colorf = ^nk_colorf;
  Pnk_vec2 = ^nk_vec2;
  Pnk_vec2i = ^nk_vec2i;
  Pnk_rect = ^nk_rect;
  Pnk_recti = ^nk_recti;
  Pnk_image = ^nk_image;
  Pnk_nine_slice = ^nk_nine_slice;
  Pnk_cursor = ^nk_cursor;
  Pnk_scroll = ^nk_scroll;
  Pnk_allocator = ^nk_allocator;
  Pnk_draw_null_texture = ^nk_draw_null_texture;
  Pnk_convert_config = ^nk_convert_config;
  Pnk_list_view = ^nk_list_view;
  Pnk_user_font = ^nk_user_font;
  PPnk_user_font = ^Pnk_user_font;
  Pnk_memory_status = ^nk_memory_status;
  Pnk_buffer_marker = ^nk_buffer_marker;
  Pnk_memory = ^nk_memory;
  Pnk_buffer = ^nk_buffer;
  Pnk_str = ^nk_str;
  Pnk_clipboard = ^nk_clipboard;
  Pnk_text_undo_record = ^nk_text_undo_record;
  Pnk_text_undo_state = ^nk_text_undo_state;
  Pnk_text_edit = ^nk_text_edit;
  Pnk_command = ^nk_command;
  Pnk_command_scissor = ^nk_command_scissor;
  Pnk_command_line = ^nk_command_line;
  Pnk_command_curve = ^nk_command_curve;
  Pnk_command_rect = ^nk_command_rect;
  Pnk_command_rect_filled = ^nk_command_rect_filled;
  Pnk_command_rect_multi_color = ^nk_command_rect_multi_color;
  Pnk_command_triangle = ^nk_command_triangle;
  Pnk_command_triangle_filled = ^nk_command_triangle_filled;
  Pnk_command_circle = ^nk_command_circle;
  Pnk_command_circle_filled = ^nk_command_circle_filled;
  Pnk_command_arc = ^nk_command_arc;
  Pnk_command_arc_filled = ^nk_command_arc_filled;
  Pnk_command_polygon = ^nk_command_polygon;
  Pnk_command_polygon_filled = ^nk_command_polygon_filled;
  Pnk_command_polyline = ^nk_command_polyline;
  Pnk_command_image = ^nk_command_image;
  Pnk_command_custom = ^nk_command_custom;
  Pnk_command_text = ^nk_command_text;
  Pnk_command_buffer = ^nk_command_buffer;
  Pnk_mouse_button = ^nk_mouse_button;
  Pnk_mouse = ^nk_mouse;
  Pnk_key = ^nk_key;
  Pnk_keyboard = ^nk_keyboard;
  Pnk_input = ^nk_input;
  Pnk_style_item = ^nk_style_item;
  Pnk_style_text = ^nk_style_text;
  Pnk_style_button = ^nk_style_button;
  Pnk_style_toggle = ^nk_style_toggle;
  Pnk_style_selectable = ^nk_style_selectable;
  Pnk_style_slider = ^nk_style_slider;
  Pnk_style_progress = ^nk_style_progress;
  Pnk_style_scrollbar = ^nk_style_scrollbar;
  Pnk_style_edit = ^nk_style_edit;
  Pnk_style_property = ^nk_style_property;
  Pnk_style_chart = ^nk_style_chart;
  Pnk_style_combo = ^nk_style_combo;
  Pnk_style_tab = ^nk_style_tab;
  Pnk_style_window_header = ^nk_style_window_header;
  Pnk_style_window = ^nk_style_window;
  Pnk_style = ^nk_style;
  Pnk_chart_slot = ^nk_chart_slot;
  Pnk_chart = ^nk_chart;
  Pnk_row_layout = ^nk_row_layout;
  Pnk_popup_buffer = ^nk_popup_buffer;
  Pnk_menu_state = ^nk_menu_state;
  Pnk_panel = ^nk_panel;
  Pnk_popup_state = ^nk_popup_state;
  Pnk_edit_state = ^nk_edit_state;
  Pnk_property_state = ^nk_property_state;
  Pnk_window = ^nk_window;
  Pnk_config_stack_style_item_element = ^nk_config_stack_style_item_element;
  Pnk_config_stack_float_element = ^nk_config_stack_float_element;
  Pnk_config_stack_vec2_element = ^nk_config_stack_vec2_element;
  Pnk_config_stack_flags_element = ^nk_config_stack_flags_element;
  Pnk_config_stack_color_element = ^nk_config_stack_color_element;
  Pnk_config_stack_user_font_element = ^nk_config_stack_user_font_element;
  Pnk_config_stack_button_behavior_element = ^nk_config_stack_button_behavior_element;
  Pnk_config_stack_style_item = ^nk_config_stack_style_item;
  Pnk_config_stack_float = ^nk_config_stack_float;
  Pnk_config_stack_vec2 = ^nk_config_stack_vec2;
  Pnk_config_stack_flags = ^nk_config_stack_flags;
  Pnk_config_stack_color = ^nk_config_stack_color;
  Pnk_config_stack_user_font = ^nk_config_stack_user_font;
  Pnk_config_stack_button_behavior = ^nk_config_stack_button_behavior;
  Pnk_configuration_stacks = ^nk_configuration_stacks;
  Pnk_table = ^nk_table;
  Pnk_page_element = ^nk_page_element;
  Pnk_page = ^nk_page;
  Pnk_pool = ^nk_pool;
  Pnk_context = ^nk_context;

  nk_char = UTF8Char;
  nk_uchar = Byte;
  nk_byte = Byte;
  Pnk_byte = ^nk_byte;
  nk_short = Smallint;
  nk_ushort = Word;
  nk_int = Integer;
  nk_uint = Cardinal;
  Pnk_uint = ^nk_uint;
  nk_size = UInt64;
  Pnk_size = ^nk_size;
  nk_ptr = UInt64;
  nk_bool = Integer;
  Pnk_bool = ^nk_bool;
  nk_hash = nk_uint;
  nk_flags = nk_uint;
  Pnk_flags = ^nk_flags;
  nk_rune = nk_uint;
  Pnk_rune = ^nk_rune;

  nk_color = record
    r: nk_byte;
    g: nk_byte;
    b: nk_byte;
    a: nk_byte;
  end;

  nk_colorf = record
    r: Single;
    g: Single;
    b: Single;
    a: Single;
  end;

  nk_vec2 = record
    x: Single;
    y: Single;
  end;

  nk_vec2i = record
    x: Smallint;
    y: Smallint;
  end;

  nk_rect = record
    x: Single;
    y: Single;
    w: Single;
    h: Single;
  end;

  nk_recti = record
    x: Smallint;
    y: Smallint;
    w: Smallint;
    h: Smallint;
  end;

  nk_glyph = array [0..3] of UTF8Char;

  nk_handle = record
    case Integer of
      0: (ptr: Pointer);
      1: (id: Integer);
  end;

  nk_image = record
    handle: nk_handle;
    w: nk_ushort;
    h: nk_ushort;
    region: array [0..3] of nk_ushort;
  end;

  nk_nine_slice = record
    img: nk_image;
    l: nk_ushort;
    t: nk_ushort;
    r: nk_ushort;
    b: nk_ushort;
  end;

  nk_cursor = record
    img: nk_image;
    size: nk_vec2;
    offset: nk_vec2;
  end;

  nk_scroll = record
    x: nk_uint;
    y: nk_uint;
  end;

  nk_plugin_alloc = function(p1: nk_handle; old: Pointer; p3: nk_size): Pointer; cdecl;

  nk_plugin_free = procedure(p1: nk_handle; old: Pointer); cdecl;

  nk_plugin_filter = function(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;

  nk_plugin_paste = procedure(p1: nk_handle; p2: Pnk_text_edit); cdecl;

  nk_plugin_copy = procedure(p1: nk_handle; const p2: PUTF8Char; len: Integer); cdecl;

  nk_allocator = record
    userdata: nk_handle;
    alloc: nk_plugin_alloc;
    free: nk_plugin_free;
  end;

  nk_draw_null_texture = record
    texture: nk_handle;
    uv: nk_vec2;
  end;

  nk_convert_config = record
    global_alpha: Single;
    line_AA: nk_anti_aliasing;
    shape_AA: nk_anti_aliasing;
    circle_segment_count: Cardinal;
    arc_segment_count: Cardinal;
    curve_segment_count: Cardinal;
    null: nk_draw_null_texture;
    vertex_layout: Pnk_draw_vertex_layout_element;
    vertex_size: nk_size;
    vertex_alignment: nk_size;
  end;

  nk_list_view = record
    begin_: Integer;
    end_: Integer;
    count: Integer;
    total_height: Integer;
    ctx: Pnk_context;
    scroll_pointer: Pnk_uint;
    scroll_value: nk_uint;
  end;

  nk_text_width_f = function(p1: nk_handle; h: Single; const p3: PUTF8Char; len: Integer): Single; cdecl;

  nk_query_font_glyph_f = procedure(handle: nk_handle; font_height: Single; glyph: Pnk_user_font_glyph; codepoint: nk_rune; next_codepoint: nk_rune); cdecl;

  nk_user_font = record
    userdata: nk_handle;
    height: Single;
    width: nk_text_width_f;
  end;

  nk_memory_status = record
    memory: Pointer;
    type_: Cardinal;
    size: nk_size;
    allocated: nk_size;
    needed: nk_size;
    calls: nk_size;
  end;

  nk_buffer_marker = record
    active: nk_bool;
    offset: nk_size;
  end;

  nk_memory = record
    ptr: Pointer;
    size: nk_size;
  end;

  nk_buffer = record
    marker: array [0..1] of nk_buffer_marker;
    pool: nk_allocator;
    type_: nk_allocation_type;
    memory: nk_memory;
    grow_factor: Single;
    allocated: nk_size;
    needed: nk_size;
    calls: nk_size;
    size: nk_size;
  end;

  nk_str = record
    buffer: nk_buffer;
    len: Integer;
  end;

  nk_clipboard = record
    userdata: nk_handle;
    paste: nk_plugin_paste;
    copy: nk_plugin_copy;
  end;

  nk_text_undo_record = record
    where: Integer;
    insert_length: Smallint;
    delete_length: Smallint;
    char_storage: Smallint;
  end;

  nk_text_undo_state = record
    undo_rec: array [0..98] of nk_text_undo_record;
    undo_char: array [0..998] of nk_rune;
    undo_point: Smallint;
    redo_point: Smallint;
    undo_char_point: Smallint;
    redo_char_point: Smallint;
  end;

  nk_text_edit = record
    clip: nk_clipboard;
    string_: nk_str;
    filter: nk_plugin_filter;
    scrollbar: nk_vec2;
    cursor: Integer;
    select_start: Integer;
    select_end: Integer;
    mode: Byte;
    cursor_at_end_of_line: Byte;
    initialized: Byte;
    has_preferred_x: Byte;
    single_line: Byte;
    active: Byte;
    padding1: Byte;
    preferred_x: Single;
    undo: nk_text_undo_state;
  end;

  nk_command = record
    type_: nk_command_type;
    next: nk_size;
  end;

  nk_command_scissor = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
  end;

  nk_command_line = record
    header: nk_command;
    line_thickness: Word;
    begin_: nk_vec2i;
    end_: nk_vec2i;
    color: nk_color;
  end;

  nk_command_curve = record
    header: nk_command;
    line_thickness: Word;
    begin_: nk_vec2i;
    end_: nk_vec2i;
    ctrl: array [0..1] of nk_vec2i;
    color: nk_color;
  end;

  nk_command_rect = record
    header: nk_command;
    rounding: Word;
    line_thickness: Word;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_rect_filled = record
    header: nk_command;
    rounding: Word;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_rect_multi_color = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    left: nk_color;
    top: nk_color;
    bottom: nk_color;
    right: nk_color;
  end;

  nk_command_triangle = record
    header: nk_command;
    line_thickness: Word;
    a: nk_vec2i;
    b: nk_vec2i;
    c: nk_vec2i;
    color: nk_color;
  end;

  nk_command_triangle_filled = record
    header: nk_command;
    a: nk_vec2i;
    b: nk_vec2i;
    c: nk_vec2i;
    color: nk_color;
  end;

  nk_command_circle = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    line_thickness: Word;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_circle_filled = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_arc = record
    header: nk_command;
    cx: Smallint;
    cy: Smallint;
    r: Word;
    line_thickness: Word;
    a: array [0..1] of Single;
    color: nk_color;
  end;

  nk_command_arc_filled = record
    header: nk_command;
    cx: Smallint;
    cy: Smallint;
    r: Word;
    a: array [0..1] of Single;
    color: nk_color;
  end;

  nk_command_polygon = record
    header: nk_command;
    color: nk_color;
    line_thickness: Word;
    point_count: Word;
    points: array [0..0] of nk_vec2i;
  end;

  nk_command_polygon_filled = record
    header: nk_command;
    color: nk_color;
    point_count: Word;
    points: array [0..0] of nk_vec2i;
  end;

  nk_command_polyline = record
    header: nk_command;
    color: nk_color;
    line_thickness: Word;
    point_count: Word;
    points: array [0..0] of nk_vec2i;
  end;

  nk_command_image = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    img: nk_image;
    col: nk_color;
  end;

  nk_command_custom_callback = procedure(canvas: Pointer; x: Smallint; y: Smallint; w: Word; h: Word; callback_data: nk_handle); cdecl;

  nk_command_custom = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    callback_data: nk_handle;
    callback: nk_command_custom_callback;
  end;

  nk_command_text = record
    header: nk_command;
    font: Pnk_user_font;
    background: nk_color;
    foreground: nk_color;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    height: Single;
    length: Integer;
    string_: array [0..0] of UTF8Char;
  end;

  nk_command_buffer = record
    base: Pnk_buffer;
    clip: nk_rect;
    use_clipping: Integer;
    userdata: nk_handle;
    begin_: nk_size;
    end_: nk_size;
    last: nk_size;
  end;

  nk_mouse_button = record
    down: nk_bool;
    clicked: Cardinal;
    clicked_pos: nk_vec2;
  end;

  nk_mouse = record
    buttons: array [0..3] of nk_mouse_button;
    pos: nk_vec2;
    prev: nk_vec2;
    delta: nk_vec2;
    scroll_delta: nk_vec2;
    grab: Byte;
    grabbed: Byte;
    ungrab: Byte;
  end;

  nk_key = record
    down: nk_bool;
    clicked: Cardinal;
  end;

  nk_keyboard = record
    keys: array [0..29] of nk_key;
    text: array [0..15] of UTF8Char;
    text_len: Integer;
  end;

  nk_input = record
    keyboard: nk_keyboard;
    mouse: nk_mouse;
  end;

  nk_style_item_data = record
    case Integer of
      0: (color: nk_color);
      1: (image: nk_image);
      2: (slice: nk_nine_slice);
  end;

  nk_style_item = record
    type_: nk_style_item_type;
    data: nk_style_item_data;
  end;

  nk_style_text = record
    color: nk_color;
    padding: nk_vec2;
  end;

  nk_style_button = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    text_background: nk_color;
    text_normal: nk_color;
    text_hover: nk_color;
    text_active: nk_color;
    text_alignment: nk_flags;
    border: Single;
    rounding: Single;
    padding: nk_vec2;
    image_padding: nk_vec2;
    touch_padding: nk_vec2;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; userdata: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; userdata: nk_handle); cdecl;
  end;

  nk_style_toggle = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    text_normal: nk_color;
    text_hover: nk_color;
    text_active: nk_color;
    text_background: nk_color;
    text_alignment: nk_flags;
    padding: nk_vec2;
    touch_padding: nk_vec2;
    spacing: Single;
    border: Single;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_selectable = record
    normal: nk_style_item;
    hover: nk_style_item;
    pressed: nk_style_item;
    normal_active: nk_style_item;
    hover_active: nk_style_item;
    pressed_active: nk_style_item;
    text_normal: nk_color;
    text_hover: nk_color;
    text_pressed: nk_color;
    text_normal_active: nk_color;
    text_hover_active: nk_color;
    text_pressed_active: nk_color;
    text_background: nk_color;
    text_alignment: nk_flags;
    rounding: Single;
    padding: nk_vec2;
    touch_padding: nk_vec2;
    image_padding: nk_vec2;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_slider = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    bar_normal: nk_color;
    bar_hover: nk_color;
    bar_active: nk_color;
    bar_filled: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    cursor_active: nk_style_item;
    border: Single;
    rounding: Single;
    bar_height: Single;
    padding: nk_vec2;
    spacing: nk_vec2;
    cursor_size: nk_vec2;
    show_buttons: Integer;
    inc_button: nk_style_button;
    dec_button: nk_style_button;
    inc_symbol: nk_symbol_type;
    dec_symbol: nk_symbol_type;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_progress = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    cursor_active: nk_style_item;
    cursor_border_color: nk_color;
    rounding: Single;
    border: Single;
    cursor_border: Single;
    cursor_rounding: Single;
    padding: nk_vec2;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_scrollbar = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    cursor_active: nk_style_item;
    cursor_border_color: nk_color;
    border: Single;
    rounding: Single;
    border_cursor: Single;
    rounding_cursor: Single;
    padding: nk_vec2;
    show_buttons: Integer;
    inc_button: nk_style_button;
    dec_button: nk_style_button;
    inc_symbol: nk_symbol_type;
    dec_symbol: nk_symbol_type;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_edit = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    scrollbar: nk_style_scrollbar;
    cursor_normal: nk_color;
    cursor_hover: nk_color;
    cursor_text_normal: nk_color;
    cursor_text_hover: nk_color;
    text_normal: nk_color;
    text_hover: nk_color;
    text_active: nk_color;
    selected_normal: nk_color;
    selected_hover: nk_color;
    selected_text_normal: nk_color;
    selected_text_hover: nk_color;
    border: Single;
    rounding: Single;
    cursor_size: Single;
    scrollbar_size: nk_vec2;
    padding: nk_vec2;
    row_padding: Single;
  end;

  nk_style_property = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    label_normal: nk_color;
    label_hover: nk_color;
    label_active: nk_color;
    sym_left: nk_symbol_type;
    sym_right: nk_symbol_type;
    border: Single;
    rounding: Single;
    padding: nk_vec2;
    edit: nk_style_edit;
    inc_button: nk_style_button;
    dec_button: nk_style_button;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_chart = record
    background: nk_style_item;
    border_color: nk_color;
    selected_color: nk_color;
    color: nk_color;
    border: Single;
    rounding: Single;
    padding: nk_vec2;
  end;

  nk_style_combo = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    label_normal: nk_color;
    label_hover: nk_color;
    label_active: nk_color;
    symbol_normal: nk_color;
    symbol_hover: nk_color;
    symbol_active: nk_color;
    button: nk_style_button;
    sym_normal: nk_symbol_type;
    sym_hover: nk_symbol_type;
    sym_active: nk_symbol_type;
    border: Single;
    rounding: Single;
    content_padding: nk_vec2;
    button_padding: nk_vec2;
    spacing: nk_vec2;
  end;

  nk_style_tab = record
    background: nk_style_item;
    border_color: nk_color;
    text: nk_color;
    tab_maximize_button: nk_style_button;
    tab_minimize_button: nk_style_button;
    node_maximize_button: nk_style_button;
    node_minimize_button: nk_style_button;
    sym_minimize: nk_symbol_type;
    sym_maximize: nk_symbol_type;
    border: Single;
    rounding: Single;
    indent: Single;
    padding: nk_vec2;
    spacing: nk_vec2;
  end;

  nk_style_window_header = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    close_button: nk_style_button;
    minimize_button: nk_style_button;
    close_symbol: nk_symbol_type;
    minimize_symbol: nk_symbol_type;
    maximize_symbol: nk_symbol_type;
    label_normal: nk_color;
    label_hover: nk_color;
    label_active: nk_color;
    align: nk_style_header_align;
    padding: nk_vec2;
    label_padding: nk_vec2;
    spacing: nk_vec2;
  end;

  nk_style_window = record
    header: nk_style_window_header;
    fixed_background: nk_style_item;
    background: nk_color;
    border_color: nk_color;
    popup_border_color: nk_color;
    combo_border_color: nk_color;
    contextual_border_color: nk_color;
    menu_border_color: nk_color;
    group_border_color: nk_color;
    tooltip_border_color: nk_color;
    scaler: nk_style_item;
    border: Single;
    combo_border: Single;
    contextual_border: Single;
    menu_border: Single;
    group_border: Single;
    tooltip_border: Single;
    popup_border: Single;
    min_row_height_padding: Single;
    rounding: Single;
    spacing: nk_vec2;
    scrollbar_size: nk_vec2;
    min_size: nk_vec2;
    padding: nk_vec2;
    group_padding: nk_vec2;
    popup_padding: nk_vec2;
    combo_padding: nk_vec2;
    contextual_padding: nk_vec2;
    menu_padding: nk_vec2;
    tooltip_padding: nk_vec2;
  end;

  nk_style = record
    font: Pnk_user_font;
    cursors: array [0..6] of Pnk_cursor;
    cursor_active: Pnk_cursor;
    cursor_last: Pnk_cursor;
    cursor_visible: Integer;
    text: nk_style_text;
    button: nk_style_button;
    contextual_button: nk_style_button;
    menu_button: nk_style_button;
    option: nk_style_toggle;
    checkbox: nk_style_toggle;
    selectable: nk_style_selectable;
    slider: nk_style_slider;
    progress: nk_style_progress;
    property_: nk_style_property;
    edit: nk_style_edit;
    chart: nk_style_chart;
    scrollh: nk_style_scrollbar;
    scrollv: nk_style_scrollbar;
    tab: nk_style_tab;
    combo: nk_style_combo;
    window: nk_style_window;
  end;

  nk_chart_slot = record
    type_: nk_chart_type;
    color: nk_color;
    highlight: nk_color;
    min: Single;
    max: Single;
    range: Single;
    count: Integer;
    last: nk_vec2;
    index: Integer;
  end;

  nk_chart = record
    slot: Integer;
    x: Single;
    y: Single;
    w: Single;
    h: Single;
    slots: array [0..3] of nk_chart_slot;
  end;

  nk_row_layout = record
    type_: nk_panel_row_layout_type;
    index: Integer;
    height: Single;
    min_height: Single;
    columns: Integer;
    ratio: PSingle;
    item_width: Single;
    item_height: Single;
    item_offset: Single;
    filled: Single;
    item: nk_rect;
    tree_depth: Integer;
    templates: array [0..15] of Single;
  end;

  nk_popup_buffer = record
    begin_: nk_size;
    parent: nk_size;
    last: nk_size;
    end_: nk_size;
    active: nk_bool;
  end;

  nk_menu_state = record
    x: Single;
    y: Single;
    w: Single;
    h: Single;
    offset: nk_scroll;
  end;

  nk_panel = record
    type_: nk_panel_type;
    flags: nk_flags;
    bounds: nk_rect;
    offset_x: Pnk_uint;
    offset_y: Pnk_uint;
    at_x: Single;
    at_y: Single;
    max_x: Single;
    footer_height: Single;
    header_height: Single;
    border: Single;
    has_scrolling: Cardinal;
    clip: nk_rect;
    menu: nk_menu_state;
    row: nk_row_layout;
    chart: nk_chart;
    buffer: Pnk_command_buffer;
    parent: Pnk_panel;
  end;

  nk_popup_state = record
    win: Pnk_window;
    type_: nk_panel_type;
    buf: nk_popup_buffer;
    name: nk_hash;
    active: nk_bool;
    combo_count: Cardinal;
    con_count: Cardinal;
    con_old: Cardinal;
    active_con: Cardinal;
    header: nk_rect;
  end;

  nk_edit_state = record
    name: nk_hash;
    seq: Cardinal;
    old: Cardinal;
    active: Integer;
    prev: Integer;
    cursor: Integer;
    sel_start: Integer;
    sel_end: Integer;
    scrollbar: nk_scroll;
    mode: Byte;
    single_line: Byte;
  end;

  nk_property_state = record
    active: Integer;
    prev: Integer;
    buffer: array [0..63] of UTF8Char;
    length: Integer;
    cursor: Integer;
    select_start: Integer;
    select_end: Integer;
    name: nk_hash;
    seq: Cardinal;
    old: Cardinal;
    state: Integer;
  end;

  nk_window = record
    seq: Cardinal;
    name: nk_hash;
    name_string: array [0..63] of UTF8Char;
    flags: nk_flags;
    bounds: nk_rect;
    scrollbar: nk_scroll;
    buffer: nk_command_buffer;
    layout: Pnk_panel;
    scrollbar_hiding_timer: Single;
    property_: nk_property_state;
    popup: nk_popup_state;
    edit: nk_edit_state;
    scrolled: Cardinal;
    tables: Pnk_table;
    table_count: Cardinal;
    next: Pnk_window;
    prev: Pnk_window;
    parent: Pnk_window;
  end;

  nk_config_stack_style_item_element = record
    address: Pnk_style_item;
    old_value: nk_style_item;
  end;

  nk_config_stack_float_element = record
    address: PSingle;
    old_value: Single;
  end;

  nk_config_stack_vec2_element = record
    address: Pnk_vec2;
    old_value: nk_vec2;
  end;

  nk_config_stack_flags_element = record
    address: Pnk_flags;
    old_value: nk_flags;
  end;

  nk_config_stack_color_element = record
    address: Pnk_color;
    old_value: nk_color;
  end;

  nk_config_stack_user_font_element = record
    address: PPnk_user_font;
    old_value: Pnk_user_font;
  end;

  nk_config_stack_button_behavior_element = record
    address: Pnk_button_behavior;
    old_value: nk_button_behavior;
  end;

  nk_config_stack_style_item = record
    head: Integer;
    elements: array [0..15] of nk_config_stack_style_item_element;
  end;

  nk_config_stack_float = record
    head: Integer;
    elements: array [0..31] of nk_config_stack_float_element;
  end;

  nk_config_stack_vec2 = record
    head: Integer;
    elements: array [0..15] of nk_config_stack_vec2_element;
  end;

  nk_config_stack_flags = record
    head: Integer;
    elements: array [0..31] of nk_config_stack_flags_element;
  end;

  nk_config_stack_color = record
    head: Integer;
    elements: array [0..31] of nk_config_stack_color_element;
  end;

  nk_config_stack_user_font = record
    head: Integer;
    elements: array [0..7] of nk_config_stack_user_font_element;
  end;

  nk_config_stack_button_behavior = record
    head: Integer;
    elements: array [0..7] of nk_config_stack_button_behavior_element;
  end;

  nk_configuration_stacks = record
    style_items: nk_config_stack_style_item;
    floats: nk_config_stack_float;
    vectors: nk_config_stack_vec2;
    flags: nk_config_stack_flags;
    colors: nk_config_stack_color;
    fonts: nk_config_stack_user_font;
    button_behaviors: nk_config_stack_button_behavior;
  end;

  nk_table = record
    seq: Cardinal;
    size: Cardinal;
    keys: array [0..58] of nk_hash;
    values: array [0..58] of nk_uint;
    next: Pnk_table;
    prev: Pnk_table;
  end;

  nk_page_data = record
    case Integer of
      0: (tbl: nk_table);
      1: (pan: nk_panel);
      2: (win: nk_window);
  end;

  nk_page_element = record
    data: nk_page_data;
    next: Pnk_page_element;
    prev: Pnk_page_element;
  end;

  nk_page = record
    size: Cardinal;
    next: Pnk_page;
    win: array [0..0] of nk_page_element;
  end;

  nk_pool = record
    alloc: nk_allocator;
    type_: nk_allocation_type;
    page_count: Cardinal;
    pages: Pnk_page;
    freelist: Pnk_page_element;
    capacity: Cardinal;
    size: nk_size;
    cap: nk_size;
  end;

  nk_context = record
    input: nk_input;
    style: nk_style;
    memory: nk_buffer;
    clip: nk_clipboard;
    last_widget_state: nk_flags;
    button_behavior: nk_button_behavior;
    stacks: nk_configuration_stacks;
    delta_time_seconds: Single;
    text_edit: nk_text_edit;
    overlay: nk_command_buffer;
    build: Integer;
    use_pool: Integer;
    pool: nk_pool;
    begin_: Pnk_window;
    end_: Pnk_window;
    active: Pnk_window;
    current: Pnk_window;
    freelist: Pnk_page_element;
    count: Cardinal;
    seq: Cardinal;
  end;

  function nk_init_default(p1: Pnk_context; const p2: Pnk_user_font): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_init_default' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_init_fixed(p1: Pnk_context; memory: Pointer; size: nk_size; const p4: Pnk_user_font): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_init_fixed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_init(p1: Pnk_context; p2: Pnk_allocator; const p3: Pnk_user_font): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_init' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_init_custom(p1: Pnk_context; cmds: Pnk_buffer; pool: Pnk_buffer; const p4: Pnk_user_font): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_init_custom' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_clear(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_clear' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_free(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_free' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_begin(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_motion(p1: Pnk_context; x: Integer; y: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_motion' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_key(p1: Pnk_context; p2: nk_keys; down: nk_bool); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_key' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_button(p1: Pnk_context; p2: nk_buttons; x: Integer; y: Integer; down: nk_bool); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_button' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_scroll(p1: Pnk_context; val: nk_vec2); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_char(p1: Pnk_context; p2: UTF8Char); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_glyph(p1: Pnk_context; const p2: nk_glyph); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_glyph' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_unicode(p1: Pnk_context; p2: nk_rune); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_unicode' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_input_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_input_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk__begin(p1: Pnk_context): Pnk_command; cdecl;
    external NUKLEAR_DLL name _PU + 'nk__begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk__next(p1: Pnk_context; const p2: Pnk_command): Pnk_command; cdecl;
    external NUKLEAR_DLL name _PU + 'nk__next' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_begin(ctx: Pnk_context; const title: PUTF8Char; bounds: nk_rect; flags: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_begin_titled(ctx: Pnk_context; const name: PUTF8Char; const title: PUTF8Char; bounds: nk_rect; flags: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_begin_titled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_end(ctx: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_find(ctx: Pnk_context; const name: PUTF8Char): Pnk_window; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_find' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_bounds(const ctx: Pnk_context): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_bounds' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_position(const ctx: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_position' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_size(const p1: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_size' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_width(const p1: Pnk_context): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_width' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_height(const p1: Pnk_context): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_height' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_panel(p1: Pnk_context): Pnk_panel; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_panel' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_content_region(p1: Pnk_context): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_content_region' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_content_region_min(p1: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_content_region_min' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_content_region_max(p1: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_content_region_max' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_content_region_size(p1: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_content_region_size' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_get_canvas(p1: Pnk_context): Pnk_command_buffer; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_canvas' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_get_scroll(p1: Pnk_context; offset_x: Pnk_uint; offset_y: Pnk_uint); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_get_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_has_focus(const p1: Pnk_context): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_has_focus' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_is_hovered(p1: Pnk_context): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_is_hovered' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_is_collapsed(ctx: Pnk_context; const name: PUTF8Char): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_is_collapsed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_is_closed(p1: Pnk_context; const p2: PUTF8Char): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_is_closed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_is_hidden(p1: Pnk_context; const p2: PUTF8Char): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_is_hidden' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_is_active(p1: Pnk_context; const p2: PUTF8Char): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_is_active' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_window_is_any_hovered(p1: Pnk_context): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_is_any_hovered' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_item_is_any_active(p1: Pnk_context): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_item_is_any_active' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_set_bounds(p1: Pnk_context; const name: PUTF8Char; bounds: nk_rect); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_set_bounds' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_set_position(p1: Pnk_context; const name: PUTF8Char; pos: nk_vec2); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_set_position' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_set_size(p1: Pnk_context; const name: PUTF8Char; p3: nk_vec2); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_set_size' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_set_focus(p1: Pnk_context; const name: PUTF8Char); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_set_focus' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_set_scroll(p1: Pnk_context; offset_x: nk_uint; offset_y: nk_uint); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_set_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_close(ctx: Pnk_context; const name: PUTF8Char); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_close' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_collapse(p1: Pnk_context; const name: PUTF8Char; state: nk_collapse_states); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_collapse' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_collapse_if(p1: Pnk_context; const name: PUTF8Char; p3: nk_collapse_states; cond: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_collapse_if' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_show(p1: Pnk_context; const name: PUTF8Char; p3: nk_show_states); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_show' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_window_show_if(p1: Pnk_context; const name: PUTF8Char; p3: nk_show_states; cond: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_window_show_if' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_set_min_row_height(p1: Pnk_context; height: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_set_min_row_height' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_reset_min_row_height(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_reset_min_row_height' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_widget_bounds(p1: Pnk_context): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_widget_bounds' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_ratio_from_pixel(p1: Pnk_context; pixel_width: Single): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_ratio_from_pixel' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_dynamic(ctx: Pnk_context; height: Single; cols: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_dynamic' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_static(ctx: Pnk_context; height: Single; item_width: Integer; cols: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_static' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_begin(ctx: Pnk_context; fmt: nk_layout_format; row_height: Single; cols: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_push(p1: Pnk_context; value: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_push' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row(p1: Pnk_context; p2: nk_layout_format; height: Single; cols: Integer; const ratio: PSingle); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_template_begin(p1: Pnk_context; row_height: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_template_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_template_push_dynamic(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_template_push_dynamic' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_template_push_variable(p1: Pnk_context; min_width: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_template_push_variable' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_template_push_static(p1: Pnk_context; width: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_template_push_static' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_row_template_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_row_template_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_space_begin(p1: Pnk_context; p2: nk_layout_format; height: Single; widget_count: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_space_push(p1: Pnk_context; bounds: nk_rect); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_push' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_layout_space_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_space_bounds(p1: Pnk_context): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_bounds' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_space_to_screen(p1: Pnk_context; p2: nk_vec2): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_to_screen' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_space_to_local(p1: Pnk_context; p2: nk_vec2): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_to_local' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_space_rect_to_screen(p1: Pnk_context; p2: nk_rect): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_rect_to_screen' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_layout_space_rect_to_local(p1: Pnk_context; p2: nk_rect): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_layout_space_rect_to_local' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_spacer(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_spacer' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_group_begin(p1: Pnk_context; const title: PUTF8Char; p3: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_group_begin_titled(p1: Pnk_context; const name: PUTF8Char; const title: PUTF8Char; p4: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_begin_titled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_group_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_group_scrolled_offset_begin(p1: Pnk_context; x_offset: Pnk_uint; y_offset: Pnk_uint; const title: PUTF8Char; flags: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_scrolled_offset_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_group_scrolled_begin(p1: Pnk_context; off: Pnk_scroll; const title: PUTF8Char; p4: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_scrolled_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_group_scrolled_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_scrolled_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_group_get_scroll(p1: Pnk_context; const id: PUTF8Char; x_offset: Pnk_uint; y_offset: Pnk_uint); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_get_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_group_set_scroll(p1: Pnk_context; const id: PUTF8Char; x_offset: nk_uint; y_offset: nk_uint); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_group_set_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_tree_push_hashed(p1: Pnk_context; p2: nk_tree_type; const title: PUTF8Char; initial_state: nk_collapse_states; const hash: PUTF8Char; len: Integer; seed: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_push_hashed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_tree_image_push_hashed(p1: Pnk_context; p2: nk_tree_type; p3: nk_image; const title: PUTF8Char; initial_state: nk_collapse_states; const hash: PUTF8Char; len: Integer; seed: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_image_push_hashed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_tree_pop(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_pop' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_tree_state_push(p1: Pnk_context; p2: nk_tree_type; const title: PUTF8Char; state: Pnk_collapse_states): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_state_push' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_tree_state_image_push(p1: Pnk_context; p2: nk_tree_type; p3: nk_image; const title: PUTF8Char; state: Pnk_collapse_states): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_state_image_push' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_tree_state_pop(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_state_pop' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_tree_element_push_hashed(p1: Pnk_context; p2: nk_tree_type; const title: PUTF8Char; initial_state: nk_collapse_states; selected: Pnk_bool; const hash: PUTF8Char; len: Integer; seed: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_element_push_hashed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_tree_element_image_push_hashed(p1: Pnk_context; p2: nk_tree_type; p3: nk_image; const title: PUTF8Char; initial_state: nk_collapse_states; selected: Pnk_bool; const hash: PUTF8Char; len: Integer; seed: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_element_image_push_hashed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_tree_element_pop(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_tree_element_pop' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_list_view_begin(p1: Pnk_context; out_: Pnk_list_view; const id: PUTF8Char; p4: nk_flags; row_height: Integer; row_count: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_list_view_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_list_view_end(p1: Pnk_list_view); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_list_view_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget(p1: Pnk_rect; const p2: Pnk_context): nk_widget_layout_states; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_fitting(p1: Pnk_rect; p2: Pnk_context; p3: nk_vec2): nk_widget_layout_states; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_fitting' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_bounds(p1: Pnk_context): nk_rect; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_bounds' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_position(p1: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_position' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_size(p1: Pnk_context): nk_vec2; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_size' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_width(p1: Pnk_context): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_width' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_height(p1: Pnk_context): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_height' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_is_hovered(p1: Pnk_context): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_is_hovered' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_is_mouse_clicked(p1: Pnk_context; p2: nk_buttons): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_is_mouse_clicked' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_widget_has_mouse_click_down(p1: Pnk_context; p2: nk_buttons; down: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_widget_has_mouse_click_down' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_spacing(p1: Pnk_context; cols: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_spacing' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; p4: nk_flags); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_text_colored(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; p4: nk_flags; p5: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_text_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_text_wrap(p1: Pnk_context; const p2: PUTF8Char; p3: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_text_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_text_wrap_colored(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; p4: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_text_wrap_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_label_colored(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; p4: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_label_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_label_wrap(p1: Pnk_context; const p2: PUTF8Char); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_label_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_label_colored_wrap(p1: Pnk_context; const p2: PUTF8Char; p3: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_label_colored_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_image_(p1: Pnk_context; p2: nk_image); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_image' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_image_color(p1: Pnk_context; p2: nk_image; p3: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_image_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelf(p1: Pnk_context; p2: nk_flags; const p3: PUTF8Char) varargs; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelf_colored(p1: Pnk_context; p2: nk_flags; p3: nk_color; const p4: PUTF8Char) varargs; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelf_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelf_wrap(p1: Pnk_context; const p2: PUTF8Char) varargs; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelf_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelf_colored_wrap(p1: Pnk_context; p2: nk_color; const p3: PUTF8Char) varargs; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelf_colored_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelfv(p1: Pnk_context; p2: nk_flags; const p3: PUTF8Char; p4: Pointer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelfv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelfv_colored(p1: Pnk_context; p2: nk_flags; p3: nk_color; const p4: PUTF8Char; p5: Pointer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelfv_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelfv_wrap(p1: Pnk_context; const p2: PUTF8Char; p3: Pointer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelfv_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_labelfv_colored_wrap(p1: Pnk_context; p2: nk_color; const p3: PUTF8Char; p4: Pointer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_labelfv_colored_wrap' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_bool(p1: Pnk_context; const prefix: PUTF8Char; p3: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_bool' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_int(p1: Pnk_context; const prefix: PUTF8Char; p3: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_int' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_uint(p1: Pnk_context; const prefix: PUTF8Char; p3: Cardinal); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_uint' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_float(p1: Pnk_context; const prefix: PUTF8Char; p3: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_color_byte(p1: Pnk_context; const prefix: PUTF8Char; p3: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_color_byte' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_color_float(p1: Pnk_context; const prefix: PUTF8Char; p3: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_color_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_value_color_hex(p1: Pnk_context; const prefix: PUTF8Char; p3: nk_color); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_value_color_hex' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_text(p1: Pnk_context; const title: PUTF8Char; len: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_label(p1: Pnk_context; const title: PUTF8Char): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_color(p1: Pnk_context; p2: nk_color): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_symbol(p1: Pnk_context; p2: nk_symbol_type): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_symbol' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_image(p1: Pnk_context; img: nk_image): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_image' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_symbol_label(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; text_alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_symbol_text(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_image_label(p1: Pnk_context; img: nk_image; const p3: PUTF8Char; text_alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_image_text(p1: Pnk_context; img: nk_image; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_text_styled(p1: Pnk_context; const p2: Pnk_style_button; const title: PUTF8Char; len: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_text_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_label_styled(p1: Pnk_context; const p2: Pnk_style_button; const title: PUTF8Char): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_label_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_symbol_styled(p1: Pnk_context; const p2: Pnk_style_button; p3: nk_symbol_type): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_symbol_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_image_styled(p1: Pnk_context; const p2: Pnk_style_button; img: nk_image): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_image_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_symbol_text_styled(p1: Pnk_context; const p2: Pnk_style_button; p3: nk_symbol_type; const p4: PUTF8Char; p5: Integer; alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_symbol_text_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_symbol_label_styled(ctx: Pnk_context; const style: Pnk_style_button; symbol: nk_symbol_type; const title: PUTF8Char; align: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_symbol_label_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_image_label_styled(p1: Pnk_context; const p2: Pnk_style_button; img: nk_image; const p4: PUTF8Char; text_alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_image_label_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_image_text_styled(p1: Pnk_context; const p2: Pnk_style_button; img: nk_image; const p4: PUTF8Char; p5: Integer; alignment: nk_flags): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_image_text_styled' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_button_set_behavior(p1: Pnk_context; p2: nk_button_behavior); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_set_behavior' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_push_behavior(p1: Pnk_context; p2: nk_button_behavior): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_push_behavior' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_button_pop_behavior(p1: Pnk_context): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_button_pop_behavior' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_check_label(p1: Pnk_context; const p2: PUTF8Char; active: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_check_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_check_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_check_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_check_flags_label(p1: Pnk_context; const p2: PUTF8Char; flags: Cardinal; value: Cardinal): Cardinal; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_check_flags_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_check_flags_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; flags: Cardinal; value: Cardinal): Cardinal; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_check_flags_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_checkbox_label(p1: Pnk_context; const p2: PUTF8Char; active: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_checkbox_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_checkbox_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_checkbox_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_checkbox_flags_label(p1: Pnk_context; const p2: PUTF8Char; flags: PCardinal; value: Cardinal): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_checkbox_flags_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_checkbox_flags_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; flags: PCardinal; value: Cardinal): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_checkbox_flags_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_radio_label(p1: Pnk_context; const p2: PUTF8Char; active: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_radio_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_radio_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_radio_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_option_label(p1: Pnk_context; const p2: PUTF8Char; active: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_option_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_option_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_option_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_selectable_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; value: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_selectable_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_selectable_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; value: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_selectable_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_selectable_image_label(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; align: nk_flags; value: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_selectable_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_selectable_image_text(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_selectable_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_selectable_symbol_label(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; align: nk_flags; value: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_selectable_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_selectable_symbol_text(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: Pnk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_selectable_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_select_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; value: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_select_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_select_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; value: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_select_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_select_image_label(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; align: nk_flags; value: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_select_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_select_image_text(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_select_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_select_symbol_label(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; align: nk_flags; value: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_select_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_select_symbol_text(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_select_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_slide_float(p1: Pnk_context; min: Single; val: Single; max: Single; step: Single): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_slide_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_slide_int(p1: Pnk_context; min: Integer; val: Integer; max: Integer; step: Integer): Integer; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_slide_int' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_slider_float(p1: Pnk_context; min: Single; val: PSingle; max: Single; step: Single): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_slider_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_slider_int(p1: Pnk_context; min: Integer; val: PInteger; max: Integer; step: Integer): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_slider_int' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_progress(p1: Pnk_context; cur: Pnk_size; max: nk_size; modifyable: nk_bool): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_progress' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_prog(p1: Pnk_context; cur: nk_size; max: nk_size; modifyable: nk_bool): nk_size; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_prog' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_color_picker(p1: Pnk_context; p2: nk_colorf; p3: nk_color_format): nk_colorf; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_color_picker' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_color_pick(p1: Pnk_context; p2: Pnk_colorf; p3: nk_color_format): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_color_pick' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_property_int(p1: Pnk_context; const name: PUTF8Char; min: Integer; val: PInteger; max: Integer; step: Integer; inc_per_pixel: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_property_int' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_property_float(p1: Pnk_context; const name: PUTF8Char; min: Single; val: PSingle; max: Single; step: Single; inc_per_pixel: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_property_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_property_double(p1: Pnk_context; const name: PUTF8Char; min: Double; val: PDouble; max: Double; step: Double; inc_per_pixel: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_property_double' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_propertyi(p1: Pnk_context; const name: PUTF8Char; min: Integer; val: Integer; max: Integer; step: Integer; inc_per_pixel: Single): Integer; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_propertyi' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_propertyf(p1: Pnk_context; const name: PUTF8Char; min: Single; val: Single; max: Single; step: Single; inc_per_pixel: Single): Single; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_propertyf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_propertyd(p1: Pnk_context; const name: PUTF8Char; min: Double; val: Double; max: Double; step: Double; inc_per_pixel: Single): Double; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_propertyd' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_edit_string(p1: Pnk_context; p2: nk_flags; buffer: PUTF8Char; len: PInteger; max: Integer; p6: nk_plugin_filter): nk_flags; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_edit_string' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_edit_string_zero_terminated(p1: Pnk_context; p2: nk_flags; buffer: PUTF8Char; max: Integer; p5: nk_plugin_filter): nk_flags; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_edit_string_zero_terminated' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_edit_buffer(p1: Pnk_context; p2: nk_flags; p3: Pnk_text_edit; p4: nk_plugin_filter): nk_flags; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_edit_buffer' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_edit_focus(p1: Pnk_context; flags: nk_flags); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_edit_focus' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_edit_unfocus(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_edit_unfocus' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_chart_begin(p1: Pnk_context; p2: nk_chart_type; num: Integer; min: Single; max: Single): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_chart_begin_colored(p1: Pnk_context; p2: nk_chart_type; p3: nk_color; active: nk_color; num: Integer; min: Single; max: Single): nk_bool; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_begin_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_chart_add_slot(ctx: Pnk_context; const p2: nk_chart_type; count: Integer; min_value: Single; max_value: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_add_slot' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_chart_add_slot_colored(ctx: Pnk_context; const p2: nk_chart_type; p3: nk_color; active: nk_color; count: Integer; min_value: Single; max_value: Single); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_add_slot_colored' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_chart_push(p1: Pnk_context; p2: Single): nk_flags; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_push' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function nk_chart_push_slot(p1: Pnk_context; p2: Single; p3: Integer): nk_flags; cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_push_slot' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_chart_end(p1: Pnk_context); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_chart_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  procedure nk_plot(p1: Pnk_context; p2: nk_chart_type; const values: PSingle; count: Integer; offset: Integer); cdecl;
    external NUKLEAR_DLL name _PU + 'nk_plot' {$IFDEF MSWINDOWS}delayed{$ENDIF};

type
  nk_plot_function_value_getter = function(user: Pointer; index: Integer): Single; cdecl;

procedure nk_plot_function(p1: Pnk_context; p2: nk_chart_type; userdata: Pointer; value_getter: nk_plot_function_value_getter; count: Integer; offset: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_plot_function' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_popup_begin(p1: Pnk_context; p2: nk_popup_type; const p3: PUTF8Char; p4: nk_flags; bounds: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_popup_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_popup_close(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_popup_close' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_popup_end(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_popup_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_popup_get_scroll(p1: Pnk_context; offset_x: Pnk_uint; offset_y: Pnk_uint); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_popup_get_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_popup_set_scroll(p1: Pnk_context; offset_x: nk_uint; offset_y: nk_uint); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_popup_set_scroll' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo(p1: Pnk_context; items: PPUTF8Char; count: Integer; selected: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_separator(p1: Pnk_context; const items_separated_by_separator: PUTF8Char; separator: Integer; selected: Integer; count: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_separator' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_string(p1: Pnk_context; const items_separated_by_zeros: PUTF8Char; selected: Integer; count: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_string' {$IFDEF MSWINDOWS}delayed{$ENDIF};

type
  nk_combo_callback_item_getter = procedure(p1: Pointer; p2: Integer; p3: PPUTF8Char); cdecl;

function nk_combo_callback(p1: Pnk_context; item_getter: nk_combo_callback_item_getter; userdata: Pointer; selected: Integer; count: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_callback' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_combobox(p1: Pnk_context; items: PPUTF8Char; count: Integer; selected: PInteger; item_height: Integer; size: nk_vec2); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combobox' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_combobox_string(p1: Pnk_context; const items_separated_by_zeros: PUTF8Char; selected: PInteger; count: Integer; item_height: Integer; size: nk_vec2); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combobox_string' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_combobox_separator(p1: Pnk_context; const items_separated_by_separator: PUTF8Char; separator: Integer; selected: PInteger; count: Integer; item_height: Integer; size: nk_vec2); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combobox_separator' {$IFDEF MSWINDOWS}delayed{$ENDIF};

type
  nk_combobox_callback_item_getter = procedure(p1: Pointer; p2: Integer; p3: PPUTF8Char); cdecl;

procedure nk_combobox_callback(p1: Pnk_context; item_getter: nk_combobox_callback_item_getter; p3: Pointer; selected: PInteger; count: Integer; item_height: Integer; size: nk_vec2); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combobox_callback' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_text(p1: Pnk_context; const selected: PUTF8Char; p3: Integer; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_label(p1: Pnk_context; const selected: PUTF8Char; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_color(p1: Pnk_context; color: nk_color; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_symbol(p1: Pnk_context; p2: nk_symbol_type; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_symbol' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_symbol_label(p1: Pnk_context; const selected: PUTF8Char; p3: nk_symbol_type; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_symbol_text(p1: Pnk_context; const selected: PUTF8Char; p3: Integer; p4: nk_symbol_type; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_image(p1: Pnk_context; img: nk_image; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_image' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_image_label(p1: Pnk_context; const selected: PUTF8Char; p3: nk_image; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_begin_image_text(p1: Pnk_context; const selected: PUTF8Char; p3: Integer; p4: nk_image; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_begin_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_item_label(p1: Pnk_context; const p2: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_item_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_item_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_item_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_item_image_label(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_item_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_item_image_text(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_item_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_item_symbol_label(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_item_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_combo_item_symbol_text(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_item_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_combo_close(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_close' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_combo_end(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_combo_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_begin(p1: Pnk_context; p2: nk_flags; p3: nk_vec2; trigger_bounds: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_item_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_item_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_item_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_item_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_item_image_label(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_item_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_item_image_text(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; len: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_item_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_item_symbol_label(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_item_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_contextual_item_symbol_text(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_item_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_contextual_close(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_close' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_contextual_end(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_contextual_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_tooltip(p1: Pnk_context; const p2: PUTF8Char); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_tooltip' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_tooltipf(p1: Pnk_context; const p2: PUTF8Char) varargs; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_tooltipf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_tooltipfv(p1: Pnk_context; const p2: PUTF8Char; p3: Pointer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_tooltipfv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_tooltip_begin(p1: Pnk_context; width: Single): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_tooltip_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_tooltip_end(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_tooltip_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_menubar_begin(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menubar_begin' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_menubar_end(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menubar_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_text(p1: Pnk_context; const title: PUTF8Char; title_len: Integer; align: nk_flags; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_image(p1: Pnk_context; const p2: PUTF8Char; p3: nk_image; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_image' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_image_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; p5: nk_image; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_image_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; p4: nk_image; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_symbol(p1: Pnk_context; const p2: PUTF8Char; p3: nk_symbol_type; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_symbol' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_symbol_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; p5: nk_symbol_type; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_begin_symbol_label(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; p4: nk_symbol_type; size: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_begin_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_item_text(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_item_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_item_label(p1: Pnk_context; const p2: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_item_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_item_image_label(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_item_image_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_item_image_text(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; len: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_item_image_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_item_symbol_text(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_item_symbol_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_menu_item_symbol_label(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; alignment: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_item_symbol_label' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_menu_close(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_close' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_menu_end(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_menu_end' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_default(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_default' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_from_table(p1: Pnk_context; const p2: Pnk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_from_table' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_load_cursor(p1: Pnk_context; p2: nk_style_cursor; const p3: Pnk_cursor); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_load_cursor' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_load_all_cursors(p1: Pnk_context; p2: Pnk_cursor); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_load_all_cursors' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_get_color_by_name(p1: nk_style_colors): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_get_color_by_name' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_set_font(p1: Pnk_context; const p2: Pnk_user_font); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_set_font' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_set_cursor(p1: Pnk_context; p2: nk_style_cursor): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_set_cursor' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_show_cursor(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_show_cursor' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_style_hide_cursor(p1: Pnk_context); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_hide_cursor' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_push_font(p1: Pnk_context; const p2: Pnk_user_font): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_push_font' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_push_float(p1: Pnk_context; p2: PSingle; p3: Single): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_push_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_push_vec2(p1: Pnk_context; p2: Pnk_vec2; p3: nk_vec2): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_push_vec2' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_push_style_item(p1: Pnk_context; p2: Pnk_style_item; p3: nk_style_item): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_push_style_item' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_push_flags(p1: Pnk_context; p2: Pnk_flags; p3: nk_flags): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_push_flags' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_push_color(p1: Pnk_context; p2: Pnk_color; p3: nk_color): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_push_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_pop_font(p1: Pnk_context): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_pop_font' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_pop_float(p1: Pnk_context): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_pop_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_pop_vec2(p1: Pnk_context): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_pop_vec2' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_pop_style_item(p1: Pnk_context): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_pop_style_item' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_pop_flags(p1: Pnk_context): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_pop_flags' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_pop_color(p1: Pnk_context): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_pop_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_(r: Integer; g: Integer; b: Integer): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_iv(const rgb: PInteger): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb_iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_bv(const rgb: Pnk_byte): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb_bv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_f(r: Single; g: Single; b: Single): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_fv(const rgb: PSingle): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_cf(c: nk_colorf): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb_cf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgb_hex(const rgb: PUTF8Char): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgb_hex' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_(r: Integer; g: Integer; b: Integer; a: Integer): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_u32(p1: nk_uint): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_u32' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_iv(const rgba: PInteger): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_bv(const rgba: Pnk_byte): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_bv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_f(r: Single; g: Single; b: Single; a: Single): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_fv(const rgba: PSingle): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_cf(c: nk_colorf): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_cf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rgba_hex(const rgb: PUTF8Char): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rgba_hex' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva_colorf(h: Single; s: Single; v: Single; a: Single): nk_colorf; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva_colorf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva_colorfv(c: PSingle): nk_colorf; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva_colorfv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_colorf_hsva_f(out_h: PSingle; out_s: PSingle; out_v: PSingle; out_a: PSingle; in_: nk_colorf); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_colorf_hsva_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_colorf_hsva_fv(hsva: PSingle; in_: nk_colorf); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_colorf_hsva_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsv(h: Integer; s: Integer; v: Integer): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsv_iv(const hsv: PInteger): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsv_iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsv_bv(const hsv: Pnk_byte): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsv_bv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsv_f(h: Single; s: Single; v: Single): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsv_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsv_fv(const hsv: PSingle): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsv_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva(h: Integer; s: Integer; v: Integer; a: Integer): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva_iv(const hsva: PInteger): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva_iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva_bv(const hsva: Pnk_byte): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva_bv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva_f(h: Single; s: Single; v: Single; a: Single): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_hsva_fv(const hsva: PSingle): nk_color; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_hsva_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_f(r: PSingle; g: PSingle; b: PSingle; a: PSingle; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_fv(rgba_out: PSingle; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_color_cf(p1: nk_color): nk_colorf; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_cf' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_d(r: PDouble; g: PDouble; b: PDouble; a: PDouble; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_d' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_dv(rgba_out: PDouble; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_dv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_color_u32(p1: nk_color): nk_uint; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_u32' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hex_rgba(output: PUTF8Char; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hex_rgba' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hex_rgb(output: PUTF8Char; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hex_rgb' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsv_i(out_h: PInteger; out_s: PInteger; out_v: PInteger; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsv_i' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsv_b(out_h: Pnk_byte; out_s: Pnk_byte; out_v: Pnk_byte; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsv_b' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsv_iv(hsv_out: PInteger; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsv_iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsv_bv(hsv_out: Pnk_byte; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsv_bv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsv_f(out_h: PSingle; out_s: PSingle; out_v: PSingle; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsv_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsv_fv(hsv_out: PSingle; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsv_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsva_i(h: PInteger; s: PInteger; v: PInteger; a: PInteger; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsva_i' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsva_b(h: Pnk_byte; s: Pnk_byte; v: Pnk_byte; a: Pnk_byte; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsva_b' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsva_iv(hsva_out: PInteger; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsva_iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsva_bv(hsva_out: Pnk_byte; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsva_bv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsva_f(out_h: PSingle; out_s: PSingle; out_v: PSingle; out_a: PSingle; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsva_f' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_color_hsva_fv(hsva_out: PSingle; p2: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_color_hsva_fv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_handle_ptr(p1: Pointer): nk_handle; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_handle_ptr' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_handle_id(p1: Integer): nk_handle; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_handle_id' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_image_handle(p1: nk_handle): nk_image; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_image_handle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_image_ptr(p1: Pointer): nk_image; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_image_ptr' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_image_id(p1: Integer): nk_image; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_image_id' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_image_is_subimage(const img: Pnk_image): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_image_is_subimage' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_subimage_ptr(p1: Pointer; w: nk_ushort; h: nk_ushort; sub_region: nk_rect): nk_image; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_subimage_ptr' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_subimage_id(p1: Integer; w: nk_ushort; h: nk_ushort; sub_region: nk_rect): nk_image; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_subimage_id' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_subimage_handle(p1: nk_handle; w: nk_ushort; h: nk_ushort; sub_region: nk_rect): nk_image; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_subimage_handle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_nine_slice_handle(p1: nk_handle; l: nk_ushort; t: nk_ushort; r: nk_ushort; b: nk_ushort): nk_nine_slice; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_nine_slice_handle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_nine_slice_ptr(p1: Pointer; l: nk_ushort; t: nk_ushort; r: nk_ushort; b: nk_ushort): nk_nine_slice; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_nine_slice_ptr' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_nine_slice_id(p1: Integer; l: nk_ushort; t: nk_ushort; r: nk_ushort; b: nk_ushort): nk_nine_slice; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_nine_slice_id' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_nine_slice_is_sub9slice(const img: Pnk_nine_slice): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_nine_slice_is_sub9slice' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_sub9slice_ptr(p1: Pointer; w: nk_ushort; h: nk_ushort; sub_region: nk_rect; l: nk_ushort; t: nk_ushort; r: nk_ushort; b: nk_ushort): nk_nine_slice; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_sub9slice_ptr' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_sub9slice_id(p1: Integer; w: nk_ushort; h: nk_ushort; sub_region: nk_rect; l: nk_ushort; t: nk_ushort; r: nk_ushort; b: nk_ushort): nk_nine_slice; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_sub9slice_id' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_sub9slice_handle(p1: nk_handle; w: nk_ushort; h: nk_ushort; sub_region: nk_rect; l: nk_ushort; t: nk_ushort; r: nk_ushort; b: nk_ushort): nk_nine_slice; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_sub9slice_handle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_murmur_hash(const key: Pointer; len: Integer; seed: nk_hash): nk_hash; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_murmur_hash' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_triangle_from_direction(result: Pnk_vec2; r: nk_rect; pad_x: Single; pad_y: Single; p5: nk_heading); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_triangle_from_direction' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_vec2_(x: Single; y: Single): nk_vec2; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_vec2' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_vec2i_(x: Integer; y: Integer): nk_vec2; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_vec2i' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_vec2v(const xy: PSingle): nk_vec2; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_vec2v' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_vec2iv(const xy: PInteger): nk_vec2; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_vec2iv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_get_null_rect(): nk_rect; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_get_null_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rect_(x: Single; y: Single; w: Single; h: Single): nk_rect; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_recti_(x: Integer; y: Integer; w: Integer; h: Integer): nk_rect; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_recti' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_recta(pos: nk_vec2; size: nk_vec2): nk_rect; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_recta' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rectv(const xywh: PSingle): nk_rect; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rectv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rectiv(const xywh: PInteger): nk_rect; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rectiv' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rect_pos(p1: nk_rect): nk_vec2; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rect_pos' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_rect_size(p1: nk_rect): nk_vec2; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_rect_size' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strlen(const str: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strlen' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_stricmp(const s1: PUTF8Char; const s2: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stricmp' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_stricmpn(const s1: PUTF8Char; const s2: PUTF8Char; n: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stricmpn' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strtoi(const str: PUTF8Char; endptr: PPUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strtoi' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strtof(const str: PUTF8Char; endptr: PPUTF8Char): Single; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strtof' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strtod(const str: PUTF8Char; endptr: PPUTF8Char): Double; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strtod' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strfilter(const text: PUTF8Char; const regexp: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strfilter' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strmatch_fuzzy_string(const str: PUTF8Char; const pattern: PUTF8Char; out_score: PInteger): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strmatch_fuzzy_string' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_strmatch_fuzzy_text(const txt: PUTF8Char; txt_len: Integer; const pattern: PUTF8Char; out_score: PInteger): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_strmatch_fuzzy_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_utf_decode(const p1: PUTF8Char; p2: Pnk_rune; p3: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_utf_decode' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_utf_encode(p1: nk_rune; p2: PUTF8Char; p3: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_utf_encode' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_utf_len(const p1: PUTF8Char; byte_len: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_utf_len' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_utf_at(const buffer: PUTF8Char; length: Integer; index: Integer; unicode: Pnk_rune; len: PInteger): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_utf_at' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_init_default(p1: Pnk_buffer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_init_default' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_init(p1: Pnk_buffer; const p2: Pnk_allocator; size: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_init' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_init_fixed(p1: Pnk_buffer; memory: Pointer; size: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_init_fixed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_info(p1: Pnk_memory_status; p2: Pnk_buffer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_info' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_push(p1: Pnk_buffer; type_: nk_buffer_allocation_type; const memory: Pointer; size: nk_size; align: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_push' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_mark(p1: Pnk_buffer; type_: nk_buffer_allocation_type); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_mark' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_reset(p1: Pnk_buffer; type_: nk_buffer_allocation_type); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_reset' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_clear(p1: Pnk_buffer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_clear' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_buffer_free(p1: Pnk_buffer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_free' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_buffer_memory(p1: Pnk_buffer): Pointer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_memory' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_buffer_memory_const(const p1: Pnk_buffer): Pointer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_memory_const' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_buffer_total(p1: Pnk_buffer): nk_size; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_buffer_total' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_init_default(p1: Pnk_str); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_init_default' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_init(p1: Pnk_str; const p2: Pnk_allocator; size: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_init' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_init_fixed(p1: Pnk_str; memory: Pointer; size: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_init_fixed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_clear(p1: Pnk_str); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_clear' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_free(p1: Pnk_str); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_free' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_append_text_char(p1: Pnk_str; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_append_text_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_append_str_char(p1: Pnk_str; const p2: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_append_str_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_append_text_utf8(p1: Pnk_str; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_append_text_utf8' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_append_str_utf8(p1: Pnk_str; const p2: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_append_str_utf8' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_append_text_runes(p1: Pnk_str; const p2: Pnk_rune; p3: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_append_text_runes' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_append_str_runes(p1: Pnk_str; const p2: Pnk_rune): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_append_str_runes' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_at_char(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_at_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_at_rune(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_at_rune' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_text_char(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_text_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_str_char(p1: Pnk_str; pos: Integer; const p3: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_str_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_text_utf8(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_text_utf8' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_str_utf8(p1: Pnk_str; pos: Integer; const p3: PUTF8Char): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_str_utf8' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_text_runes(p1: Pnk_str; pos: Integer; const p3: Pnk_rune; p4: Integer): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_text_runes' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_insert_str_runes(p1: Pnk_str; pos: Integer; const p3: Pnk_rune): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_insert_str_runes' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_remove_chars(p1: Pnk_str; len: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_remove_chars' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_remove_runes(str: Pnk_str; len: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_remove_runes' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_delete_chars(p1: Pnk_str; pos: Integer; len: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_delete_chars' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_str_delete_runes(p1: Pnk_str; pos: Integer; len: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_delete_runes' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_at_char(p1: Pnk_str; pos: Integer): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_at_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_at_rune(p1: Pnk_str; pos: Integer; unicode: Pnk_rune; len: PInteger): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_at_rune' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_rune_at(const p1: Pnk_str; pos: Integer): nk_rune; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_rune_at' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_at_char_const(const p1: Pnk_str; pos: Integer): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_at_char_const' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_at_const(const p1: Pnk_str; pos: Integer; unicode: Pnk_rune; len: PInteger): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_at_const' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_get(p1: Pnk_str): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_get' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_get_const(const p1: Pnk_str): PUTF8Char; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_get_const' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_len(p1: Pnk_str): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_len' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_str_len_char(p1: Pnk_str): Integer; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_str_len_char' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_default(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_default' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_ascii(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_ascii' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_float(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_float' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_decimal(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_decimal' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_hex(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_hex' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_oct(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_oct' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_filter_binary(const p1: Pnk_text_edit; unicode: nk_rune): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_filter_binary' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_init_default(p1: Pnk_text_edit); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_init_default' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_init(p1: Pnk_text_edit; p2: Pnk_allocator; size: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_init' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_init_fixed(p1: Pnk_text_edit; memory: Pointer; size: nk_size); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_init_fixed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_free(p1: Pnk_text_edit); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_free' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_text(p1: Pnk_text_edit; const p2: PUTF8Char; total_len: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_delete(p1: Pnk_text_edit; where: Integer; len: Integer); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_delete' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_delete_selection(p1: Pnk_text_edit); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_delete_selection' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_select_all(p1: Pnk_text_edit); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_select_all' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_textedit_cut(p1: Pnk_text_edit): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_cut' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_textedit_paste(p1: Pnk_text_edit; const p2: PUTF8Char; len: Integer): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_paste' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_undo(p1: Pnk_text_edit); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_undo' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_textedit_redo(p1: Pnk_text_edit); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_textedit_redo' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_line(b: Pnk_command_buffer; x0: Single; y0: Single; x1: Single; y1: Single; line_thickness: Single; p7: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_line' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_curve(p1: Pnk_command_buffer; p2: Single; p3: Single; p4: Single; p5: Single; p6: Single; p7: Single; p8: Single; p9: Single; line_thickness: Single; p11: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_curve' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_rect(p1: Pnk_command_buffer; p2: nk_rect; rounding: Single; line_thickness: Single; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_circle(p1: Pnk_command_buffer; p2: nk_rect; line_thickness: Single; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_circle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_arc(p1: Pnk_command_buffer; cx: Single; cy: Single; radius: Single; a_min: Single; a_max: Single; line_thickness: Single; p8: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_arc' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_triangle(p1: Pnk_command_buffer; p2: Single; p3: Single; p4: Single; p5: Single; p6: Single; p7: Single; line_thichness: Single; p9: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_triangle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_polyline(p1: Pnk_command_buffer; points: PSingle; point_count: Integer; line_thickness: Single; col: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_polyline' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_stroke_polygon(p1: Pnk_command_buffer; p2: PSingle; point_count: Integer; line_thickness: Single; p5: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_stroke_polygon' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_fill_rect(p1: Pnk_command_buffer; p2: nk_rect; rounding: Single; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_fill_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_fill_rect_multi_color(p1: Pnk_command_buffer; p2: nk_rect; left: nk_color; top: nk_color; right: nk_color; bottom: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_fill_rect_multi_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_fill_circle(p1: Pnk_command_buffer; p2: nk_rect; p3: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_fill_circle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_fill_arc(p1: Pnk_command_buffer; cx: Single; cy: Single; radius: Single; a_min: Single; a_max: Single; p7: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_fill_arc' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_fill_triangle(p1: Pnk_command_buffer; x0: Single; y0: Single; x1: Single; y1: Single; x2: Single; y2: Single; p8: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_fill_triangle' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_fill_polygon(p1: Pnk_command_buffer; p2: PSingle; point_count: Integer; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_fill_polygon' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_draw_image(p1: Pnk_command_buffer; p2: nk_rect; const p3: Pnk_image; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_draw_image' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_draw_nine_slice(p1: Pnk_command_buffer; p2: nk_rect; const p3: Pnk_nine_slice; p4: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_draw_nine_slice' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_draw_text(p1: Pnk_command_buffer; p2: nk_rect; const text: PUTF8Char; len: Integer; const p5: Pnk_user_font; p6: nk_color; p7: nk_color); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_draw_text' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_push_scissor(p1: Pnk_command_buffer; p2: nk_rect); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_push_scissor' {$IFDEF MSWINDOWS}delayed{$ENDIF};

procedure nk_push_custom(p1: Pnk_command_buffer; p2: nk_rect; p3: nk_command_custom_callback; usr: nk_handle); cdecl;
  external NUKLEAR_DLL name _PU + 'nk_push_custom' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_has_mouse_click(const p1: Pnk_input; p2: nk_buttons): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_has_mouse_click' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_has_mouse_click_in_rect(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_has_mouse_click_in_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_has_mouse_click_down_in_rect(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect; down: nk_bool): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_has_mouse_click_down_in_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_click_in_rect(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_click_in_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_click_down_in_rect(const i: Pnk_input; id: nk_buttons; b: nk_rect; down: nk_bool): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_click_down_in_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_any_mouse_click_in_rect(const p1: Pnk_input; p2: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_any_mouse_click_in_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_prev_hovering_rect(const p1: Pnk_input; p2: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_prev_hovering_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_hovering_rect(const p1: Pnk_input; p2: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_hovering_rect' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_mouse_clicked(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_mouse_clicked' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_down(const p1: Pnk_input; p2: nk_buttons): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_down' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_pressed(const p1: Pnk_input; p2: nk_buttons): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_pressed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_mouse_released(const p1: Pnk_input; p2: nk_buttons): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_mouse_released' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_key_pressed(const p1: Pnk_input; p2: nk_keys): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_key_pressed' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_key_released(const p1: Pnk_input; p2: nk_keys): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_key_released' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_input_is_key_down(const p1: Pnk_input; p2: nk_keys): nk_bool; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_input_is_key_down' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_item_color_(p1: nk_color): nk_style_item; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_item_color' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_item_image_(img: nk_image): nk_style_item; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_item_image' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_item_nine_slice_(slice: nk_nine_slice): nk_style_item; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_item_nine_slice' {$IFDEF MSWINDOWS}delayed{$ENDIF};

function nk_style_item_hide(): nk_style_item; cdecl;
  external NUKLEAR_DLL name _PU + 'nk_style_item_hide' {$IFDEF MSWINDOWS}delayed{$ENDIF};

implementation

end.
