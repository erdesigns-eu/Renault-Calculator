﻿//------------------------------------------------------------------------------
// UNIT           : untMain.pas
// CONTENTS       : Radio Code Calculator for Renault
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open Source - Copyright © Ernst Reidinga
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 05/05/2024
//------------------------------------------------------------------------------
unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

//------------------------------------------------------------------------------
// CLASSES
//------------------------------------------------------------------------------
type
  /// <summary>
  ///   Radio Code Calculator Main Form
  /// </summary>
  TfrmMain = class(TForm)
    bvImageLine: TBevel;
    imgLogo: TImage;
    pnlBottom: TPanel;
    bvPnlLine: TBevel;
    btnAbout: TButton;
    btnCalculate: TButton;
    pnlSerialNumber: TPanel;
    lblSerialNumber: TLabel;
    edtSerialNumber: TEdit;
    pnlRadioCode: TPanel;
    lblRadioCode: TLabel;
    edtRadioCode: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
// FORM ON CREATE
//------------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Set the caption
  Caption := Application.Title;
  // Set the labels captions
  lblSerialNumber.Caption := 'Precode:';
  lblRadioCode.Caption    := 'Radio Code:';
  // Set the button captions
  btnCalculate.Caption := 'Calculate..';
  btnAbout.Caption := 'About..';
end;

//------------------------------------------------------------------------------
// CALCULATE RADIO CODE
//------------------------------------------------------------------------------
procedure TfrmMain.btnCalculateClick(Sender: TObject);

  function Validate(const Input: string; var ErrorMessage: string): Boolean;
  begin
    // Initialize result
    Result := True;
    // Clear the error message
    ErrorMessage := '';

    // Make sure the input is 4 characters long
    if not (Length(Input) = 4) then
    begin
      ErrorMessage := 'Must be 4 characters long!';
      Exit(False);
    end;

    // Make sure the input starts with a letter
    if not CharInSet(Input[1], ['A'..'Z']) then
    begin
      ErrorMessage := 'First character must be a letter!';
      Exit(False);
    end;

    // Make sure the second character is a digit
    if not (CharInSet(Input[2], ['0'..'9'])) then
    begin
      ErrorMessage := 'Second character must be a digit!';
      Exit(False);
    end;

    // Make sure the third character is a digit
    if not (CharInSet(Input[3], ['0'..'9'])) then
    begin
      ErrorMessage := 'Third character must be a digit!';
      Exit(False);
    end;

    // Make sure the fourth character is a digit
    if not (CharInSet(Input[4], ['0'..'9'])) then
    begin
      ErrorMessage := 'Fourth character must be a digit!';
      Exit(False);
    end;

    // The input can not start with A0
    if (UpperCase(Input[1]) = 'A') and (UpperCase(Input[2]) = '0') then
    begin
      ErrorMessage := 'Can not start with A0!';
      Exit(False);
    end;
  end;

var
  ErrorMessage: string;
  X, Y, Z, C: Integer;
  Input: string;
begin
  // Clear the error message
  ErrorMessage := '';

  // Check if the serial number is valid
  if not Validate(edtSerialNumber.Text, ErrorMessage) then
  begin
    MessageBox(Handle, PChar(ErrorMessage), PChar(Application.Title), MB_ICONWARNING + MB_OK);
    Exit;
  end;

  // Set the input
  Input := edtSerialNumber.Text;

  // Calculate the code
  X := Ord(Input[2]) + (Ord(Input[1])) * 10 - 698;
  Y := Ord(Input[4]) + (Ord(Input[3])) * 10 + X - 528;
  Z := (Y * 7) mod 100;
  C := (Z div 10) + (Z mod 10) * 10 + ((259 mod X) mod 100) * 100;

  // Format the code for the output
  edtRadioCode.Text := Format('%.*d', [4, C]);
end;

//------------------------------------------------------------------------------
// SHOW ABOUT DIALOG
//------------------------------------------------------------------------------
procedure TfrmMain.btnAboutClick(Sender: TObject);
const
  AboutText: string =
    'Renault Radio Code Calculator'                                      + sLineBreak + sLineBreak +
    'by Ernst Reidinga - ERDesigns'                                      + sLineBreak +
    'Version 1.0 (05/2024)'                                              + sLineBreak + sLineBreak +
    'Usage:'                                                             + sLineBreak +
    'Enter the last 4 characters of the precode and press "calculate".'  + sLineBreak +
    'These usually start with a character, followed by 3 digits.';
begin
  MessageBox(Handle, PChar(AboutText), PChar(Caption), MB_ICONINFORMATION + MB_OK);
end;

end.
