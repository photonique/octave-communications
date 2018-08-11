//Copyright (C) 2003 David Bateman
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License as
// published by the Free Software Foundation; either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, see
// <http://www.gnu.org/licenses/>.
//
// In addition to the terms of the GPL, you are permitted to link this
// program with any Open Source program, as defined by the Open Source
// Initiative (www.opensource.org)

#if !defined (galois_octave_ops_h)
#define galois_octave_ops_h 1

// Override the operator and function definition defines from Octave

#define DEFBINOP_OP_G(name, t1, t2, op) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois \
      (v1.t1 ## _value () op v2.t2 ## _value ()); \
  }

#define DEFBINOP_FN_G(name, t1, t2, f) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois (f (v1.t1 ## _value (), v2.t2 ## _value ())); \
  }

#define DEFBINOP_OP_B_S1(name, t1, t2, op) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return octave_value \
      (v1.matrix_value () op v2.t2 ##_value ()); \
  }

#define DEFBINOP_FN_B_S1(name, t1, t2, f) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return octave_value (f (v1.matrix_value (), v2.t2 ## _value ())); \
  }

#define DEFBINOP_OP_G_S1(name, t1, t2, op) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois \
      (v1.matrix_value () op v2.t2 ## _value ()); \
  }

#define DEFBINOP_FN_G_S1(name, t1, t2, f) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois (f (v1.matrix_value (), v2.t2 ## _value ())); \
  }

#define DEFBINOP_OP_B_S2(name, t1, t2, op) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return octave_value \
      (v1.t1 ## _value () op v2.matrix_value ()); \
  }

#define DEFBINOP_FN_B_S2(name, t1, t2, f) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return octave_value (f (v1.t1 ## _value (), v2.matrix_value ())); \
  }

#define DEFBINOP_OP_G_S2(name, t1, t2, op) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois \
      (v1.t1 ## _value () op v2.matrix_value ()); \
  }

#define DEFBINOP_FN_G_S2(name, t1, t2, f) \
  BINOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (const octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois (f (v1.t1 ## _value (), v2.matrix_value ())); \
  }

#define DEFCATOP_G_FN(name, t1, t2, f) \
  CATOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois (f (v1.t1 ## _value (), v2.t2 ## _value (), \
                                 ra_idx)); \
  }

#define DEFCATOP_G_METHOD(name, t1, t2, f) \
  CATOPDECL (name, a1, a2) \
  { \
    CAST_BINOP_ARGS (octave_ ## t1&, const octave_ ## t2&); \
    return new octave_galois (v1.t1 ## _value (). f (v2.t2 ## _value (), \
                                                     ra_idx)); \
  }

#define INSTALL_G_CATOP(t1, t2, f) INSTALL_CATOP (t1, t2, f)

#endif

/*
;;; Local Variables: ***
;;; mode: C++ ***
;;; End: ***
*/
