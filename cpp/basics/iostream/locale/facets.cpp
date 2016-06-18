#include <locale>
#include <iostream>
#include <iterator>
#include <string>

/// A useful class to represent an amount of currency.
//
/// There is no way to change the amount after construction!
template<typename T>
struct Currency
{
    Currency(T value) : _val(value) {}
    T value() const { return _val; }

private:
    T const _val;
};

/// Our custom moneypunct facet to format currency as it's done in Germany
template<typename charT, bool Intl = false>
struct GermanPunct : public std::moneypunct<charT, Intl>
{
    GermanPunct(size_t refs = 0) : std::moneypunct<charT, Intl>(refs) {}
    virtual ~GermanPunct() {}

protected:
    typedef typename std::moneypunct<charT>::string_type string_type;
    typedef typename std::moneypunct<charT>::char_type char_type;
    typedef typename std::moneypunct<charT>::pattern pattern;

    virtual string_type do_curr_symbol() const { return "€"; }
    virtual char_type do_thousands_sep() const { return '.'; }
    virtual std::string do_grouping() const { return "\003"; }
    virtual string_type do_positive_sign() const { return "+"; }
    virtual string_type do_negative_sign() const { return "-"; }
    virtual char_type do_decimal_point() const { return ','; }
    virtual int do_frac_digits() const { return 2; }
    virtual pattern do_pos_format() const {
        pattern const p = {
            { 
                std::moneypunct<charT>::sign,
                std::moneypunct<charT>::value,
                std::moneypunct<charT>::symbol,
                std::moneypunct<charT>::none
            }
        };
        return p;
    }
    virtual pattern do_neg_format() const {
        return do_pos_format();
    }
};

/// The ostream output operator for our Currency class
template<typename charT, typename T>
std::basic_ostream<charT>&
operator<<(std::basic_ostream<charT>& o, Currency<T> const& c)
{
    typedef typename std::basic_ostream<charT>::char_type char_type;
    typedef std::ostreambuf_iterator<char_type, std::char_traits<char_type> >
        iterator;
    typedef std::money_put<char_type, iterator> money_put;
  
    std::ostream::sentry s(o);
    if (!s) return o;
    
    // Locales are reference counted, so that copying them
    // is generally trivial.
    std::locale loc = o.getloc();
    money_put const& mp = std::use_facet<money_put>(loc);

    iterator begin(o);
    mp.put(begin, false, o, ' ', c.value());

    return o;
}

int main()
{
    // Create a locale based on the current output locale, but with
    // the monetary facet replaced by our custom one.
    // Note that facets are reference-counted by the standard library. 
    // By default they will be destroyed when no references remain.
    std::locale loc(std::cout.getloc(), new GermanPunct<char>());
    std::cout.imbue(loc);

    Currency<int> const t(13453334);
    Currency<int> const t2(-13453334);

    // The currency symbol is only displayed when showbase
    // is active.
    std::cout << std::showbase << t << "\n";
    std::cout << std::showbase << t2 << "\n";

    std::cout<<"imbue again"<<std::endl;
    std::cout.imbue(std::locale(""));
    std::cout << std::showbase << t << "\n";
    std::cout << std::showbase << t2 << "\n";
}
