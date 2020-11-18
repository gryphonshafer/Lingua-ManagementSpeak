# NAME

Lingua::ManagementSpeak - Tool to generate managerial-sounding text and full documents

# VERSION

version 1.03

[![test](https://github.com/gryphonshafer/Lingua-ManagementSpeak/workflows/test/badge.svg)](https://github.com/gryphonshafer/Lingua-ManagementSpeak/actions?query=workflow%3Atest)
[![codecov](https://codecov.io/gh/gryphonshafer/Lingua-ManagementSpeak/graph/badge.svg)](https://codecov.io/gh/gryphonshafer/Lingua-ManagementSpeak)

# SYNOPSIS

    use Lingua::ManagementSpeak;
    my $ms = Lingua::ManagementSpeak->new;

    print $ms->words(
        'pronoun article sub_conjunc power_word verb aux_verb adjective ' .
        'noun to_be conj_adverb conjuntor adverb phrase maybe_1/2_phrase'
    );

    print $ms->sentence;
    print $ms->sentence(1);
    print $ms->paragraph;
    print $ms->paragraph(2);
    print $ms->paragraph(2, 3);

    print join("\n\n", $ms->paragraphs(2));
    print join("\n\n", $ms->paragraphs(2, 1));
    print join("\n\n", $ms->paragraphs(2, 1, 3));
    print join("\n\n", $ms->bullets);
    print join("\n\n", $ms->bullets(3));
    print $ms->header;
    print $ms->header(5);
    print join(', ', $ms->structure);
    print join(', ', $ms->structure(3, 3, 5));

    my $body_default = $ms->body;
    my $body_custom  = $ms->body({
        p_min   => 2,
        p_max   => 4,
        p_s_min => 1,
        p_s_max => 1,
        b_freq  => 20,
        b_min   => 4,
        b_max   => 6
    });

    my $document_default = $ms->document;
    my $document_custom  = $ms->document(
        [ 1, 2, 2, 1, 2 ],
        {
            p_min   => 1,
            p_max   => 2,
            p_s_min => 1,
            p_s_max => 3,
            b_freq  => 40,
            b_min   => 3,
            b_max   => 4
        }
    );

    print $ms->to_html($document_custom);

# DESCRIPTION

This module generates (probably) grammatically correct, managerial-sounding text
and full-length documents that mean absolutely nothing. It can output sentences,
paragraphs, and whole documents with embedded structure. The goal is to easily
provide filler or lorem ipsen content that has the potential to pass as real.
This module does for geeks what lorem ipsen does for designers.

Most common cases are the need to create whole documents or just a paragraph
with a few sentences.

    $ms->document;
    $ms->paragraph;

This being said, there are methods that let you hook in at just about any
useful level between word and document.

# METHODS

The most commonly used method (at least for me) is `document()`. It calls
several other methods internally and returns a randomly generated document
based on some good defaults. However, you can tap into the process at
a variety of levels.

## new

Simple instantiator. Nothing special.

    my $ms = Lingua::ManagementSpeak->new;

## words

Using a text string of meta words, this returns a management-speak
block of text. It parses the meta string and converts each meta word into
a randomly picked associated real word.

    my $real_words = $ms->words($meta_words_string);
    print $ms->words('verb article adjective noun');

Currently supported meta words include:

- noun

    Nouns like: paradigms, interfaces, solutions, markets, and synergies

- verb

    Verbs like: expedite, revolutionize, visualize, facilitate, and maximize

- pronoun

    Pronouns: I, we, and they.

- adjective

    Adjectives like: innovative, extensible, seamless, distributed, and interactive

- adverb

    Adverbs like: expediting, revolutionizing, visualizing, facilitating,
    and maximizing

- aux\_verb

    Auxilary verbs: will, shall, may, might, can, could, must, ought to,
    should, would, and need to

- article

    Articles: the, your, my, our, this, and its

- conjuntor

    Conjuntors: though, although, notwithstanding, yet, still

- sub\_conjunc

    Subordinate conjuntors like: even though, if, in order that, so that, and until

- power\_word

    So-called management "power words" like:
    assured, discovered, sketched, communicated, examine, and modified

- conj\_adverb

    Conjunctive adverbs: however, moreover, nevertheless, and consequently

- to\_be

    This looks at the preceding word and conjugates the verb "to be" accordingly,
    placing it next in the returned string.

- phrase

    This is a keyword that gets literally translated into:
    "conjuntor article noun to\_be power\_word"

- maybe\_n/n\_word

    This is a fun little keyword that says, "insert 'word' here every n/n times."
    For example, "maybe\_1/4\_noun" will insert a random noun at this point in
    the string 25% of the time. This also works with stuff like "phrase" to give
    you "maybe\_1/2\_phrase" things.

The meta string gets searched for these keywords, so you can usually insert
extra text into the meta string and it will come through as expected:

    print $ms->words('I need you to verb the adjective noun.');
    # Might return: "I need you to expedite the customized interfaces."

## sentence

This returns a fully-formed sentence randomly selected from a set of
pre-defined patterns. It accepts a true or false input. If true, the returned
sentence is assumed to be the lead sentence of a paragraph and will therefore
not contain a leading conjunctive adverb. The default is false, which means
there is a 1/4 change of a leading conjunctive adverb.

    print $ms->sentence(1);
    # Might return: "Our mindshare engages open-source architectures."

    print $ms->sentence;
    # Might return:
    #   "Consequently, our mindshare engages open-source architectures."

## paragraph

This returns a paragraph with a certain number of constructed sentences.
It accepts either two or one integers. If passed two, it returns a paragraph
consisting of n sentences where n is between the two integers.
(The lower integer should get passed in first.) If passed
only one, then it returns that number of sentences. If no integers are
passed, it returns between 4 and 7 sentences.

    print $ms->paragraph;       # Returns between 4 and 7 sentences.
    print $ms->paragraph(2);    # Returns 2 sentences.
    print $ms->paragraph(2, 5); # Returns between 2 and 5 sentences.

## paragraphs

This returns a set of paragraphs. You can optionally supply a number of
paragraphs to return and sentence parameters like sentence count per
paragraph or a range for sentence count.

    my @paragraphs1 = $ms->paragraphs($total_paragraphs, $sentence_count);
    my @paragraphs2 = $ms->paragraphs(
        $total_paragraphs,
        $sentence_min,
        $sentence_max
    );

    # Returns two paragraphs
    my @paragraphs3 = $ms->paragraphs(2);

    # Returns two paragraphs, each with three sentences
    my @paragraphs4 = $ms->paragraphs(2, 3);

    # Returns two paragraphs, each with between one and three sentences
    my @paragraphs5 = $ms->paragraphs(2, 1, 3);

## bullets

This returns a certain number of bullet items, either defined or random.
The elements within each set of bullets will be written in parallel
structure, but each set may be different than the others. Each bullet is
just a string that's capitalized.

    my @bullets = $ms->bullets(5); # Returns five bullet items (just strings)

There are no periods at the end of each bullet. If you want your bulletted
lists to have periods, you have to add them yourself; but you shouldn't,
because periods at the end of bullet items are dumb.

## body

This will build a "body" chunk that you might find inside any given section
of a document. It will only ever contain paragraphs and bulletted lists.
The method returns a reference to an array where each element is a reference
to a hash containing two keys: type and text. Type will be either paragraph or
bullet.

It accepts parameters in a reference to a hash as follows:

    my $ref_to_array = $ms->body({
        p_min   => 2,  # Minimum number of paragraphs to return
        p_max   => 4,  # Maximum number of paragraphs to return
        p_s_min => 1,  # Minimum number of sentences in a paragraph
        p_s_max => 1,  # Maximum number of sentences in a paragraph
        b_freq  => 20, # % chance of a bulletted list after each paragraph
        b_min   => 4,  # Minimum number of bullet items in a bulletted list
        b_max   => 6   # Maximum number of bullet items in a bulletted list
    });

Note that `body()` will work without any parameters.

By the way, if you're reading this far into the POD, you've earned the
privilege to gripe about any bugs you find.

The data structure of `$ref_to_array` might look something like this:

    [
        {
            type => 'paragraph',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'bullet',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'bullet',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'paragraph',
            text => 'blah ... blah ... blah'
        }
    ]

## header

This returns a correctly formatted (meaning most words will appear in
upper-case) text string for use as a header. It accepts a single whole number
integer between 5 and 1 that represents the "level" of header.
Header 1 is highest, 2 is next, etc.
If no integer is given, it will randomly pick a number between 5 and 1.

    my $header = $ms->header(3);
    # Might return: "Monetizing Distributed Partnerships"

## structure

This returns an array of numbers, each number representing a "heading level"
for a document structure. The purpose of this method is to build what could
pass for a real document's information architecture.

    my @structure1 = $ms->structure;
    my @structure2 = $ms->structure($block_limit, $depth_limit, $mimimum_length);

`$block_limit` is the maximum of any similar heading level within the same
parent level. `$depth_limit` is how deep the levels are allowed to nest.
`$minimum_length` is, well, the minimum length.

## document

This is my favorite function. It builds a complete document with a structure
and body sections containing paragraphs and bulletted lists.
It returns a reference to an array containing hash references, similar to body.
It works solo, but it can optionally accept a reference to an array with
the document structure and a reference to a hash containing body parameters.

    my $ref_to_array1 = $ms->document;
    my $ref_to_array2 = $ms->document(\@structure,    \%body_parameters);
    my $ref_to_array3 = $ms->document($ms->structure, \%body_parameters);

The "type" for each header will be referenced along with it's level. For
example, a header 1 will be `header1`.
The data structure of `$ref_to_array1` might look something like this:

    [
        {
            type => 'header1',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'paragraph',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'bullet',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'bullet',
            text => 'blah ... blah ... blah'
        },
        {
            type => 'paragraph',
            text => 'blah ... blah ... blah'
        }
    ]

## to\_html

This accepts either a `body()` or `document()` result and converts it into
mostly good HTML. By mostly, I mean that you could probably parse it with
some simple regexes, but it ain't gonna validate against the W3C.

    my $html_body = $ms->to_html($ms->body);
    my $html_doc  = $ms->to_html($ms->document);

I tossed this in here because I use this functionality a lot. If you want to
build real web pages, you should probably use something better than this
function.

# SEE ALSO

You can also look for additional information at:

- [GitHub](https://github.com/gryphonshafer/Lingua-ManagementSpeak)
- [MetaCPAN](https://metacpan.org/pod/Lingua::ManagementSpeak)
- [GitHub Actions](https://github.com/gryphonshafer/Lingua-ManagementSpeak/actions)
- [Codecov](https://codecov.io/gh/gryphonshafer/Lingua-ManagementSpeak)
- [CPANTS](http://cpants.cpanauthors.org/dist/Lingua-ManagementSpeak)
- [CPAN Testers](http://www.cpantesters.org/distro/L/Lingua-ManagementSpeak.html)

# AUTHOR

Gryphon Shafer <gryphon@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Gryphon Shafer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
