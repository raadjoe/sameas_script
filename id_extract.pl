:- module(
  id_extract,
  [
    extract_explicit/0,
    extract_schema/0
  ]
).

/** <module> Identity extraction

@author Wouter Beek
@version 2017-2018
*/

:- use_module(library(debug)).

:- use_module(library(conf_ext)).
:- use_module(library(file_ext)).
:- use_module(library(semweb/hdt_file)).
:- use_module(library(semweb/rdf_export)).

:- debug(id_extract).





%! extract_explicit is det.
%
% Extracts the extension of the $\texttt{owl:sameAs}$ relation and
% creates an HDT file that contains this extension.
%
% The HDT file can be used to efficiently traverse the identity
% extension graph.

extract_explicit :-
  cli_argument('lod-a-lot', FromFile),
  hdt_call_file(FromFile, extract_explicit_),
  hdt_create(FromFile).
extract_explicit_(Hdt) :-
  cli_argument(dir, ., ToDir),
  directory_file_path(ToDir, 'sameas-explicit.nt', ToFile),
  write_to_file(ToFile, extract_explicit_(Hdt)).
extract_explicit_(Hdt, Out) :-
  forall(
    hdt_tp0(Hdt, S, owl:sameAs, O),
    rdf_write_triple(Out, S, owl:sameAs, O)
  ).



%! extract_schema is det.

extract_schema :-
  cli_argument('lod-a-lot', FromFile),
  hdt_call_file(FromFile, extract_schema_).
extract_schema_(Hdt) :-
  cli_argument(dir, ., Dir),
  directory_file_path(Dir, 'sameas-schema.nt', File),
  write_to_file(File, extract_schema_(Hdt)).
extract_schema_(Hdt, Out) :-
  forall(
    hdt_tp0(Hdt, owl:sameAs, P, O),
    rdf_write_triple(Out, owl:sameAs, P, O)
  ),
  forall(
    hdt_tp0(Hdt, S, P, owl:sameAs),
    rdf_write_triple(Out, S, P, owl:sameAs)
  ).
