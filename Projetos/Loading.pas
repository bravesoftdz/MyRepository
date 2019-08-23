unit Loading;

interface

uses System.SysUtils, System.UITypes, FMX.Types, FMX.Controls, FMX.StdCtrls,
      FMX.Objects, FMX.Effects, FMX.Layouts, FMX.Forms, FMX.Graphics, FMX.Ani,
      FMX.VirtualKeyboard, FMX.Platform;

type
  TLoading = Class

    private

      Class var Layout: TLayout;
      Class var Fundo : TRectangle;
      Class Var Arco : TArc;
      Class var Mensagem : TLabel;
      Class var Animacao : TFloatAnimation;

    public

      Class Procedure Show(Const Frm : Tform; Const msg : string);
      Class Procedure Hide;

  End;

implementation

{ TLoading }

class procedure TLoading.Hide;
begin
      if Assigned (Layout) then
      begin
            try
                  if Assigned(Mensagem) then
                            Mensagem.DisposeOf;

                  if Assigned(Animacao) then
                            Animacao.DisposeOf;

                  if Assigned(Arco) then
                            Arco.DisposeOf;

                  if Assigned(Fundo) then
                            Fundo.DisposeOf;

                  if Assigned(Layout) then
                            Layout.DisposeOf;

            except

            end;
      end;

      Mensagem := nil;
      Animacao := nil;
      Arco     := nil;
      Layout   := nil;
      Fundo    := nil;

end;

class procedure TLoading.Show(const Frm: Tform; const msg: string);

Var
      FService : IFMXVirtualKeyboardService;

begin
      //Panel de Fundo Opaco ...
      Fundo             := TRectangle.Create(Frm);
      Fundo.Opacity     := 0;
      Fundo.Parent      := Frm;
      Fundo.Visible     := True;
      Fundo.Align       := TAlignLayout.Contents;
      Fundo.Fill.Color  := TAlphaColorRec.Black;
      Fundo.Fill.Kind   := TBrushKind.Solid;
      Fundo.Stroke.Kind := TBrushKind.None;
      Fundo.Visible     := True;

      // Layout Contendo TEXTO & ARCO...
      Layout            := TLayout.Create(Frm);
      Layout.Opacity    := 0;
      Layout.Parent     := Frm;
      Layout.Visible    := True;
      Layout.Align      := TAlignLayout.Contents;
      Layout.Width      := 250;
      Layout.Height     := 78;
      Layout.Visible    := True;

      // ARCO da Animação...
      Arco                  :=  TArc.Create(Frm);
      Arco.Visible          := True;
      Arco.Parent           := Layout;
      Arco.Align            := TAlignLayout.Center;
      Arco.Margins.Bottom   := 55;
      Arco.Width            := 25;
      Arco.Height           := 25;
      Arco.EndAngle         := 280;
      Arco.Stroke.Color     := $FFFEFFFF;
      Arco.Stroke.Thickness := 2;
      Arco.Position.X       := trunc ((Layout.Width - Arco.Width) / 2);
      Arco.Position.Y       := 0;

      // ANIMAÇÃO ...
      Animacao                := TFloatAnimation.Create(Frm);
      Animacao.Parent         := Arco;
      Animacao.StartValue     := 0;
      Animacao.StopValue      := 360;
      Animacao.Duration       := 0.8;
      Animacao.Loop           := True;
      Animacao.PropertyName   := 'RotationAngle';
      Animacao.AnimationType  := TAnimationType.InOut;
      Animacao.Interpolation  := TInterpolationType.Linear;
      Animacao.Start;

      //  Label do TEXTO ...
      Mensagem := TLabel.Create(Frm);
      Mensagem.Parent := Layout;
      Mensagem.Align := TAlignLayout.Center;
      Mensagem.Margins.Top  := 60;
      Mensagem.Font.Size := 13;
      Mensagem.Height  := 70;
      Mensagem.Width := Frm.Width - 100;
      Mensagem.FontColor  := $FFFEFFFF;
      Mensagem.TextSettings.HorzAlign := TTextAlign.Center;
      Mensagem.TextSettings.VertAlign := TTextAlign.Leading;
      Mensagem.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
      Mensagem.Text := msg;
      Mensagem.VertTextAlign  := TTextAlign.Leading;
      Mensagem.Trimming := TTextTrimming.None;
      Mensagem.TabStop := False;
      Mensagem.SetFocus;

      // Exibe os controles...
      Fundo.AnimateFloat ('Opacity', 0.7);
      Layout.AnimateFloat('Opacity', 1);
      Layout.BringToFront;

      // Esconder teclado Virtual...
      TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                         IInterface(FService));
      if (FService <> nil) then
      begin
          FService.HideVirtualKeyboard;
      end;
      FService := nil;


end;

end.
