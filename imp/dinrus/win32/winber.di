/***********************************************************************\
*                                winber.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.winber;

/* Comment from MinGW
  winber.h - Header file for the Windows LDAP Basic Кодировка Rules API

  Written by Filip Navara <xnavara@volny.cz>

  Ссылки:
    The C LDAP Application Program Interface
    http://www.watersprings.org/pub/id/draft-ietf-ldapext-ldap-c-api-05.txt

    Lightweight Directory Access Protocol Reference
    http://msdn.microsoft.com/library/en-us/netdir/ldap/ldap_reference.asp

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

/* Opaque structure
 *	http://msdn.microsoft.com/library/en-us/ldap/ldap/berelement.asp
 */
struct BerElement;

alias цел ber_int_t, ber_slen_t;
alias бцел ber_uint_t, ber_len_t, ber_tag_t;

align(4):
struct BerValue {
	ber_len_t bv_len;
	сим*     bv_val;
}
alias BerValue LDAP_BERVAL, BERVAL;
alias BerValue* PLDAP_BERVAL, PBERVAL;

const ber_tag_t
	LBER_ERROR   = -1,
	LBER_DEFAULT = -1,
	LBER_USE_DER =  1;

/*	FIXME: In MinGW, these are WINBERAPI == DECLSPEC_IMPORT.  Linkage
 *	attribute?
 */
extern (C) {
	BerElement* ber_init(BerValue*);
	цел ber_printf(BerElement*, сим*, ...);
	цел ber_flatten(BerElement*, BerValue**);
	ber_tag_t ber_scanf(BerElement*, сим*, ...);
	ber_tag_t ber_peek_tag(BerElement*, ber_len_t*);
	ber_tag_t ber_skip_tag(BerElement*, ber_len_t*);
	ber_tag_t ber_first_element(BerElement*, ber_len_t*, сим**);
	ber_tag_t ber_next_element(BerElement*, ber_len_t*, сим*);
	проц ber_bvfree(BerValue*);
	проц ber_bvecfree(BerValue**);
	проц ber_free(BerElement*, цел);
	BerValue* ber_bvdup(BerValue*);
	BerElement* ber_alloc_t(цел);
}
