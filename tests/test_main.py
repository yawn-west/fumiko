from fumiko.main import main
from pytest import CaptureFixture


def test_main(capsys: CaptureFixture[str]) -> None:
    """Test the main function."""
    main()
    captured = capsys.readouterr()
    assert "Welcome to Fumiko!" in captured.out
