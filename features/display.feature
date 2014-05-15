Feature: Search GHC's errors/warnings by using Helm
  In order to confirm and move GHC's errors/wanings quickly,
  it uses thoes information as Helm source.
  ghc-mod package provides nice interactive feature to
  highlight for error/warning lines and display the details.
  This feature makes use of the "ghc-mod" feature for Helm.

  Scenario: Show errors
    Given I open "test/Data/Error.hs"
    When I am in buffer "Error.hs"
     And I press "M-x ghc-check-syntax"
     And ghc-mod may highlight error/wanring lines within "5" sec
    When I press "M-x helm-ghc-display-errors/warnings"
    Then I switch to buffer "*helm*"
     And I should see:
      """
      GHC Errors/Warnings
      Error.hs:5:Error

      Not in scope: ‘func’
      --------------------
      Error.hs:8:Error

      The type signature for ‘foo’ lacks an accompanying binding

      """

  Scenario: Show warnings
    Given I open "test/Data/Warning.hs"
    When I am in buffer "Warning.hs"
     And I press "M-x ghc-check-syntax"
     And ghc-mod may highlight error/wanring lines within "5" sec
    When I press "M-x helm-ghc-display-errors/warnings"
    Then I switch to buffer "*helm*"
     And I should see:
      """
      GHC Errors/Warnings
      Warning.hs:1:Warning

      The import of ‘Data.List’ is redundant
        except perhaps to import instances from ‘Data.List’
      To import instances alone, use: import Data.List()
      --------------------
      Warning.hs:9:Warning

      Defined but not used: ‘x’
      --------------------
      Warning.hs:9:Warning

      Defaulting the following constraint(s) to type ‘Integer’
        (Num t0) arising from the literal ‘20’
      In the first argument of ‘return’, namely ‘20’
      In a stmt of a 'do' block: x <- return 20
      In the expression:
        do { foo;
             x <- return 20;
             return () }

      """
