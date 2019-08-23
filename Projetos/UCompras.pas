unit UCompras;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.Components, Data.Bind.DBScope,
  FMX.ListView, FireDAC.Comp.DataSet, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.DialogService,FMX.DialogService.Async,
  FMX.Colors, FMX.TabControl, FMX.ExtCtrls, FMX.Layouts, FMX.ListBox,
  FMX.MultiView, System.Actions, FMX.ActnList, FMX.Edit,
  FMX.Objects, FMX.Ani;


type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    ButtonDelete: TButton;
    ButtonAdd: TButton;
    FDConnectionCompras: TFDConnection;
    FDQueryCreatTable: TFDQuery;
    Label1: TLabel;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    FDQueryDescricao: TFDQuery;
    LinkFillControlToFielddescricao: TLinkFillControlToField;
    BindingsList1: TBindingsList;
    FDQueryNovaDescricao: TFDQuery;
    FDQueryExcluir: TFDQuery;
    MultiView1: TMultiView;
    btVoltar: TButton;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ActionList1: TActionList;
    ChangeTab: TChangeTabAction;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ToolBar2: TToolBar;
    Label2: TLabel;
    BTMultiview: TSpeedButton;
    TabControl: TTabControl;
    Layout4: TLayout;
    ImageViewer1: TImageViewer;
    Layout5: TLayout;
    Label12: TLabel;
    Label13: TLabel;
    ImageViewer2: TImageViewer;
    Brush1: TBrushObject;
    Layout1: TLayout;
    procedure ButtonAddClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
    const AItem: TListViewItem);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FDConnectionComprasBeforeConnect(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure btVoltarClick(Sender: TObject);
    procedure btVoltaPrincipalClick(Sender: TObject);
    procedure ButtonAddMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ButtonAddMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ListBoxItem1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ListBoxItem1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure BTMultiviewClick(Sender: TObject);



  private

    { Private declarations }
    procedure EntradaProduto(const md: TModalResult; const produtos:array of string);

    //variaveis da calculadora






  public



  end;

var
  Form1: TForm1;


implementation

{$R *.fmx}

uses  System.IOUtils, Loading;
 procedure TForm1.BTMultiviewClick(Sender: TObject);
begin
      Layout1.Visible := True;
      Layout4.Visible := True
end;

procedure TForm1.btVoltaPrincipalClick(Sender: TObject);
begin
ChangeTab.Tab := TabItem1;
 ChangeTab.ExecuteTarget(self);
end;

procedure TForm1.btVoltarClick(Sender: TObject);
begin
 ChangeTab.Tab := TabItem1;
 ChangeTab.ExecuteTarget(self);
end;

procedure TForm1.ButtonAddClick(Sender: TObject);
var descricao : array [0..0] of string;
begin
  descricao[0] := String.Empty;
  InputQuery('Cadastre um Produto',['Produto:'],descricao,Self.EntradaProduto);
end;

procedure TForm1.ButtonAddMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    ButtonAdd.Opacity := 0.5;
end;

procedure TForm1.ButtonAddMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ButtonAdd.Opacity := 1;
end;

procedure TForm1.ButtonDeleteClick(Sender: TObject);
  var descricao : String;
begin
  descricao := TListViewItem(ListView1.Selected).Text;
   try
      FDQueryExcluir.ParamByName('descricao').AsString := descricao;
      FDQueryExcluir.ExecSql();
      FDQueryDescricao.Close();
      FDQueryDescricao.Open();
      ButtonDelete.Visible := ListView1.Selected <> nil;
      ShowMessage('Produto EXCLUIDO com sucesso!');


  except
    on e : Exception do
    begin
      ShowMessage(e.Message);
    end;

  end;
end;

procedure TForm1.EntradaProduto(const md: TModalResult;
  const produtos: array of string);
Var descricao :String;
begin
  descricao := String.Empty;
  if md <> mrOK then
  Exit;
  descricao := produtos[0];
  try
    if (descricao.Trim <> '') then
    Begin
      FDQueryNovaDescricao.ParamByName('descricao').AsString := descricao;
      FDQueryNovaDescricao.ExecSql();
      FDQueryDescricao.Close();
      FDQueryDescricao.Open();
      ButtonDelete.Visible := ListView1.Selected <> nil;
      End;

  except
    on e : Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;

end;

procedure TForm1.FDConnectionComprasBeforeConnect(Sender: TObject);
begin
{$IF DEFINED(android)}
  FDConnectionCompras.Params.Values['DataBase'] := TPath.Combine(TPath.GetDocumentsPath, 'Compras.s3db');

{$ENDIF}
end;

procedure TForm1.ListBoxItem1Click(Sender: TObject);
begin
 ChangeTab.Tab := TabItem1;
  ChangeTab.ExecuteTarget(self);
    Multiview1.HideMaster;
end;

procedure TForm1.ListBoxItem1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ListBoxItem1.Opacity := 0.5;
end;

procedure TForm1.ListBoxItem1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ListBoxItem1.Opacity := 1;
end;

procedure TForm1.ListBoxItem2Click(Sender: TObject);
begin

      FDQueryDescricao.Open();
      ChangeTab.Tab := TabItem2;
      ChangeTab.ExecuteTarget(self);

       TLoading.Show(Form1, 'Carregando...');

      TThread.CreateAnonymousThread(procedure
      begin

            TThread.Synchronize(nil, procedure
            begin
               TLoading.Hide;
            end);

      end).Start;

end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
     ButtonDelete.Visible := ListView1.Selected <> nil;
end;
end.
